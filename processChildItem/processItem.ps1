#!/usr/bin/pwsh
[CmdletBinding()]
param (
    $folder,
    $item,
    $log,
    [switch]$leaf,
    [switch]$utf8,
    [switch]$utf8bom,
    [switch]$container,
    [switch]$hexdump,
    [switch]$addbom,
    [switch]$delbom,
    [switch]$undo,
    [Parameter(ValueFromRemainingArguments=$true)]$args
)
# 使い方
function Usage {
    Write-Host ('{0} フォルダ アイテム [ログファイル] [-leaf] [-container] [-utf8] [-utf8bom] [-hexdump] [-addbom] [-delbom] [-undo]' -f $Script:MyInvocation.MyCommand.Name)
    Write-Host ''
    Write-Host '【機  能】'
    Write-Host "`t対象に合うアイテムに処理を行う"
    Write-Host ''
    Write-Host '【引き数】'
    Write-Host "`tフォルダ`t処理したいフォルダ"
    Write-Host "`tアイテム`t処理したいファイルまたはフォルダ"
    Write-Host "`tログファイル`t作成したいログファイル"
    Write-Host '対象'
    Write-Host "`tleaf`tファイル"
    Write-Host "`tcontainer`tフォルダ"
    Write-Host "`tutf8`tutf8(BOM無し)、utf8を指定するとleafも指定"
    Write-Host "`tutf8bom`tutf8(BOM有り)、utf8bomを指定するとleafも指定"
    Write-Host '処理'
    Write-Host "`hexdump`t16進数ダンプ"
    Write-Host "`addbom`tBOM付与、addbomを指定するとutf8も指定"
    Write-Host "`delbom`tBOM削除、delbomを指定するとutf8bomも指定"
    Write-Host "`tundo`t変更を元に戻す(未サポート)"
    Write-Host ''
    Write-Host '【その他】'
    Write-Host ("`tログファイルを指定しないと{0}になる" -f (Join-Path 'フォルダ' ($Script:MyInvocation.MyCommand.Name + '.log')))
}
# 比較長さ
$compCount = 1024
# utf8(BOM無し)
$utf8Infos = @{
    noboms = (
        , (, (0xef, 0xbb, 0xbf))
    )
    bins = (
        ((, 0x00), (, 0x7f)),
        ((0xc2, 0x80), (0xdf, 0xbf)),
        ((0xe0, 0x80, 0x80), (0xef, 0xbf, 0xbf)),
        ((0xf0, 0x80, 0x80, 0x80), (0xf4, 0xbf, 0xbf, 0xbf))
    )
}
# utf8(BOM有り)
$utf8bomInfos = @{
    boms = (
        , (, (0xef, 0xbb, 0xbf))
    )
    bins = (
        ((, 0x00), (, 0x7f)),
        ((0xc2, 0x80), (0xdf, 0xbf)),
        ((0xe0, 0x80, 0x80), (0xef, 0xbf, 0xbf)),
        ((0xf0, 0x80, 0x80, 0x80), (0xf4, 0xbf, 0xbf, 0xbf))
    )
}
# 2つの配列を長さと内容で比較、長さを指定すると長さまで比較
# 2つ目が1つ目より大きいと+
# 2つ目が1つ目と等しいと0
# それ以外は-を返却
function CompElement {
    param (
        $aElement,
        $bElement,
        $length
    )
    # 配列の長さを取得
    $aLength = $aElement.Count
    $bLength = $bElement.Count
    # 指定の長さに合わせる
    if ($null -ne $length) {
        if ($length -lt $aLength) {
            $aLength = $length
        }
        if ($length -lt $bLength) {
            $bLength = $length
        }
    }
    # 長さで比較
    $result = $bLength - $aLength
    if (0 -eq $result) {
        # 内容で比較
        for ($cnt = 0; $cnt -lt $aLength; ++$cnt) {
            $result = $bElement[$cnt] - $aElement[$cnt]
            if (0 -ne $result) {
                break
            }
        }
    }
    return $result
}
# ファイルタイプを取得
function GetFileType {
    param (
        $item,
        [switch]$utf8,
        [switch]$utf8bom
    )
    $fileInfos = @(
        ($utf8, $utf8Infos),
        ($utf8bom, $utf8bomInfos)
    )
    foreach ($fileInfos in $fileInfos) {
        if ($fileInfos[0]) {
            try {
                $fs = New-Object System.IO.FileStream($item, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
                $br = New-Object System.IO.BinaryReader($fs)
                $bytes = $br.ReadBytes($compCount)
                $nexts = $br.ReadBytes(1)
                $startCount = 0
                if ($fileInfos[1].ContainsKey('noboms')) {
                    # NOBOMを検査
                    $result = $false
                    foreach ($nobom in $fileInfos[1].noboms) {
                        $endCount = $startCount + $nobom[0].Count - 1
                        if (0 -ne $nexts.Count -and
                            $bytes.Count - 1 -le $endCount) {
                            $endCount = $bytes.Count - 1
                        }
                        $resultLow = CompElement $bytes[$startCount..$endCount] $nobom[0] ($endCount - $startCount + 1)
                        if (1 -lt $nobom.Count) {
                            $resultHi = CompElement $bytes[$startCount..$endCount] $nobom[1] ($endCount - $startCount + 1)
                        } else {
                            $resultHi = $resultLow
                        }
                        if (0 -ge $resultLow -and
                            0 -le $resultHi) {
                            $result = $true
                            break
                        }
                    }
                    if ($result) {
                        return $false
                    }
                }
                if ($fileInfos[1].ContainsKey('boms')) {
                    # BOMを検査
                    $result = $false
                    foreach ($bom in $fileInfos[1].boms) {
                        $endCount = $startCount + $bom[0].Count - 1
                        if (0 -ne $nexts.Count -and
                            $bytes.Count - 1 -le $endCount) {
                            $endCount = $bytes.Count - 1
                        }
                        $resultLow = CompElement $bytes[$startCount..$endCount] $bom[0] ($endCount - $startCount + 1)
                        if (1 -lt $bom.Count) {
                            $resultHi = CompElement $bytes[$startCount..$endCount] $bom[1] ($endCount - $startCount + 1)
                        } else {
                            $resultHi = $resultLow
                        }
                        if (0 -ge $resultLow -and
                            0 -le $resultHi) {
                            $result = $true
                            $startCount = $endCount + 1
                            break
                        }
                    }
                    if (-not($result)) {
                        return $false
                    }
                }
                if ($fileInfos[1].ContainsKey('bins')) {
                    # バイナリを検査
                    while ($bytes.Count -ne $startCount) {
                        $result = $false
                        foreach ($bin in $fileInfos[1].bins) {
                            $endCount = $startCount + $bin[0].Count - 1
                            if (0 -ne $nexts.Count -and
                                $bytes.Count - 1 -le $endCount) {
                                $endCount = $bytes.Count - 1
                            }
                            $resultLow = CompElement $bytes[$startCount..$endCount] $bin[0] ($endCount - $startCount + 1)
                            if (1 -lt $bin.Count) {
                                $resultHi = CompElement $bytes[$startCount..$endCount] $bin[1] ($endCount - $startCount + 1)
                            } else {
                                $resultHi = $resultLow
                            }
                            if (0 -ge $resultLow -and
                                0 -le $resultHi) {
                                $result = $true
                                $startCount = $endCount + 1
                                break
                            }
                        }
                        if (-not($result)) {
                            return $false
                        }
                    }
                }
                return $true
            } catch {
                Write-Host (
                    '{0} {1} {2} 異常終了' -f (
                        ($_.InvocationInfo.PositionMessage -replace '\s+', ' '),
                        ($_.Exception.Message -replace '\s+', ' '),
                        $_.CategoryInfo.ToString()
                    )
                )
                throw New-Object Exception
            } finally {
                $br.Close()
                $fs.Close()
            }
        }
    }
    return $true
}
# ファイルタイプを設定
function SetFileType {
    param (
        $item,
        [switch]$addbom,
        [switch]$delbom
    )
    try {
        $fs = New-Object System.IO.FileStream($item, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
        $br = New-Object System.IO.BinaryReader($fs)
        $bytes = @()
        # addbomはutf8(BOM有り)のBOMを付与
        if ($addbom) {
            $bytes += $utf8bomInfos.boms[0][0]
        }
        # addbom、delbomはutf8(BOM有り)のBOM分だけを読み飛ばす
        if ($addbom -or
            $delbom) {
            $bytes2 = $br.ReadBytes($utf8bomInfos.boms[0][0].Count)
            # BOMか確認しBOMで無い場合は連結
            $result = CompElement $bytes2 $utf8bomInfos.boms[0][0]
            if (0 -ne $result) {
                $bytes += $bytes2
            }
        }
        # ファイルを読み込んで連結
        $bytes += $br.ReadBytes($fs.Length - $fs.Position)
        $br.Close()
        $fs.Close()
        [System.IO.File]::WriteAllBytes($item, $bytes);
    } catch {
        Write-Host (
            '{0} {1} {2} 異常終了' -f (
                ($_.InvocationInfo.PositionMessage -replace '\s+', ' '),
                ($_.Exception.Message -replace '\s+', ' '),
                $_.CategoryInfo.ToString()
            )
        )
        throw New-Object Exception
} finally {
        $br.Close()
        $fs.Close()
    }
    return $true
}
# 余計な引き数が指定されていれば異常終了
if ($null -ne $args) {
    Write-Host '余計な引き数が指定されています異常終了'
    Usage
    exit -1
}
# フォルダが指定されていなければ異常終了
if ($null -eq $folder) {
    Write-Host 'フォルダに指定されていません異常終了'
    Usage
    exit -1
}
# ログファイルが指定されていなければデフォルト設定
if ($null -eq $log) {
    $log = Join-Path $folder ($Script:MyInvocation.MyCommand.Name + '.log')
}
# アイテム、ログファイルはエスケープ
if ($null -ne $item) {
    $escItem = [System.Management.Automation.WildcardPattern]::Escape($item)
}
$escLog = [System.Management.Automation.WildcardPattern]::Escape($log)
# 処理
# undoを指定しない場合
if (-not($undo)) {
    # アイテムを指定しない場合
    if ($null -eq $item) {
        # ログファイルに何かが存在すれば異常終了
        if (Test-Path $escLog) {
            Write-Host 'ログファイルに何かが存在します異常終了'
            Usage
            exit -1
        }
        # 処理
        # addbomを指定する場合
        if ($addbom) {

        }
        # delbomを指定する場合
        if ($delbom) {

        }
    # アイテムにログファイルを指定する場合
    } elseif ($log -eq $item) {

    # アイテムを指定する場合
    } else {
        # 引き数の前処理
        if ($addbom) {
            $utf8 = $true
        }
        if ($delbom) {
            $utf8bom = $true
        }
        if ($utf8 -or
            $utf8bom) {
            $leaf = $true
        }
        # 対象
        if ((-not($leaf) -or (Test-Path $escItem -PathType Leaf)) -and
            (-not($container) -or (Test-Path $escItem -PathType Container)) -and
            (-not($utf8) -or (GetFileType $item -utf8)) -and
            (-not($utf8bom) -or (GetFileType $item -utf8bom))) {
            # 処理
            # hexdumpを指定する場合
            if ($hexdump) {
                Write-Output $item
                [System.IO.File]::ReadAllBytes($item) | Format-Hex | ForEach-Object { $_ -replace "`r`n", '' }
            # 何も指定しない場合
            } else {
                Write-Output $item
            }
            # addbomを指定する場合
            if ($addbom) {
                $null = SetFileType $item -addbom
                # hexdumpを指定する場合
                if ($hexdump) {
                    Write-Output $item
                    [System.IO.File]::ReadAllBytes($item) | Format-Hex | ForEach-Object { $_ -replace "`r`n", '' }
                }
            }
            # delbomを指定する場合
            if ($delbom) {
                $null = SetFileType $item -delbom
                # hexdumpを指定する場合
                if ($hexdump) {
                    Write-Output $item
                    [System.IO.File]::ReadAllBytes($item) | Format-Hex | ForEach-Object { $_ -replace "`r`n", '' }
                }
            }
        }
    }
# undoを指定する場合
} else {
    # アイテムが指定されていれば異常終了
    if ($null -ne $item) {
        Write-Host 'アイテムに指定されています異常終了'
        Usage
        exit -1
    }
    # ログファイルにファイルが存在しなければ異常終了
    if (-not(Test-Path $escLog -PathType Leaf)) {
        Write-Host 'ログファイルにファイルが存在しません異常終了'
        Usage
        exit -1
    }
    # undoは未サポート
    $csvs = Import-Csv $escLog
    [array]::Reverse($csvs)
    foreach ($csv in $csvs) {

    }
    # ログファイルを削除
    Remove-Item $escLog -Force 2>&1 > $null
    if (-not($?)) {
        Write-Host 'ログファイルが削除できません異常終了'
        Usage
        exit -1
    }
    # undoによる正常終了
    exit 1
}
# 正常終了
exit 0
