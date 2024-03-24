#!/usr/bin/env pwsh
[CmdletBinding()]
param (
    [string]$path,
    [string]$filter,
    [switch]$noRecurse,
    [Parameter(ValueFromRemainingArguments = $true)]$args
)
# 使い方
function Usage {
    Write-Host ('{0}' -f $script:MyInvocation.MyCommand.Name)
}
# 余計な引き数が指定されていれば異常終了
if ($null -ne $args) {
    Write-Host '余計な引き数が指定されています異常終了'
    Usage
    exit -1
}

# 2つの配列を長さで比較
# 1つ目の配列が長い2
# 2つ目の配列が長い-2
# 1つ目の配列が大きい1
# 2つ目の配列が大きい-1
# 同じ0
# それ以外は3を返却
function Compare-Element {
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
    $result = [System.Math]::Sign($aLength - $bLength) * 2
    if (0 -eq $result) {
        # 内容で比較
        for ($cnt = 0; $cnt -lt $aLength; ++$cnt) {
            $resultTemp = [System.Math]::Sign($aElement[$cnt] - $bElement[$cnt])
            if (0 -lt $cnt) {
                if ((0 -lt $resultOld -and 0 -gt $resultTemp) -or
                (0 -gt $resultOld -and 0 -lt $resultTemp)) {
                    $result = 3
                    break
                }
                if (0 -ne $resultTemp) {
                    $result = $resultTemp
                }
            } else {
                $result = $resultTemp
            }
            $resultOld = $result
        }
    }
    return $result
}

$boms = (
    ((0xef, 0xbb, 0xbf), (0xef, 0xbb, 0xbf), 'bom'),
    (@(), @(), '')
)

$bins = (
    ((, 0x00), (, 0x7f), 'utf8'),
    ((0xc2, 0x80), (0xdf, 0xbf), 'utf8'),
    ((0xe0, 0x80, 0x80), (0xef, 0xbf, 0xbf), 'utf8'),
    ((0xf0, 0x80, 0x80, 0x80), (0xf4, 0xbf, 0xbf, 0xbf), 'utf8'),
    ((, 0x00), (, 0xff), 'unknown')
)

Get-ChildItem $path $filter -Recurse:(!$noRecurse) -File | ForEach-Object {
    # Write-Host $_.FullName
    $result = [PSCustomObject]@{
        file = $_.FullName
        bom = ''
        encode = ''
    }
    $fs = [System.IO.FileStream]::new($_.FullName, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
    $br = [System.IO.BinaryReader]::new($fs)
    $bytes = $br.ReadBytes(1024)
    $index = 0
    $encodes = @{}
    foreach ($bom in $boms) {
        $bytesTemp = $bytes[$index..($index + $bom[0].Count - 1)]
        if (0 -lt ((0, 1) -eq (Compare-Element $bytesTemp $bom[0] $bom[0].Count)).Count -and
        0 -lt ((-1, 0) -eq (Compare-Element $bytesTemp $bom[1] $bom[1].Count)).Count) {
            $result.bom = $bom[2]
            $index += $bom[0].Count
            break
        }
    }
    for (;;) {
        # Write-Host $index
        if ($bytes.Count -le $index) {
            break
        }
        $index2 = 0
        foreach ($bin in $bins) {
            $bytesTemp = $bytes[$index..($index + $bin[0].Count - 1)]
            if (0 -lt ((0, 1) -eq (Compare-Element $bytesTemp $bin[0] $bin[0].Count)).Count -and
            0 -lt ((-1, 0) -eq (Compare-Element $bytesTemp $bin[1] $bin[1].Count)).Count) {
                $encodes[$bin[2]]++
                $index += $bin[0].Count
                break
            }
            $index2++
        }
        if ($bins.Count -le $index2) {
            break
        }
    }
    $maxValue = $encodes.Values | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
    $maxKey = $encodes.GetEnumerator() | Where-Object { $_.Value -eq $maxValue } | Select-Object -ExpandProperty Key
    $result.encode = $maxKey
    $result
    $br.Close()
    $fs.Close()
}

return 0
