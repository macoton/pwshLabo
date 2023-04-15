#!/usr/bin/pwsh
[CmdletBinding()]
param (
    $folder,
    $scr,
    $log,
    [Parameter(ValueFromRemainingArguments=$true)]$args
)
# 使い方
function Usage {
    Write-Host ('{0} フォルダ [スクリプト] [ログファイル] [-args 引き数]' -f $Script:MyInvocation.MyCommand.Name)
    Write-Host ''
    Write-Host '【機  能】'
    Write-Host "`tフォルダの子にスクリプトを実行"
    Write-Host ''
    Write-Host '【引き数】'
    Write-Host "`tフォルダ`t処理したいフォルダ"
    Write-Host "`tスクリプト`t処理したいスクリプト"
    Write-Host "`tログファイル`t作成したいログファイル"
    Write-Host "`t引き数`t処理したい引き数"
}
# フォルダが指定されていなければ異常終了
if ($null -eq $folder) {
    Write-Host 'フォルダに指定されていません異常終了'
    Usage
    exit -1
}
# スクリプトが指定されていなければデフォルト設定
if ($null -eq $scr) {
    $scr = Join-Path (Split-Path $Script:MyInvocation.MyCommand.Path -Parent) 'processItem.ps1'
}
# フォルダにフォルダが存在しなければ異常終了
if (-not(Test-Path $folder -PathType Container)) {
    Write-Host 'フォルダにフォルダが存在しません異常終了'
    Usage
    exit -1
}
# 引き数を連結
$argsall = ''
if ($null -ne $log) {
    $argsall += " `"{0}`"" -f $log
}
if ($null -ne $args) {
    foreach ($arg in $args) {
        if ('-' -eq $arg[0]) {
            $argsall += ' {0}' -f $arg
        } else {
            $argsall += " `"{0}`"" -f $arg
        }
    }
}
# スクリプトを実行
try {
    Invoke-Expression ("{0} `"{1}`"{2}" -f $scr, $folder, $argsall)
    if (0 -ne $LASTEXITCODE -and
        1 -ne $LASTEXITCODE) {
        exit -1
    }
} catch {
    Write-Host (
        '{0} {1} {2} 異常終了' -f (
            ($_.InvocationInfo.PositionMessage -replace '\s+', ' '),
            ($_.Exception.Message -replace '\s+', ' '),
            $_.CategoryInfo.ToString()
        )
    )
    throw New-Object Exception
}
# 処理継続であれば処理継続
if (0 -eq $LASTEXITCODE) {
    # フォルダを親配列に追加
    $parents = @($folder)
    while (0 -lt $parents.Count) {
        # 親配列から親を取得
        $parent = $parents[0]
        $parents = $parents[1..$parents.Count]
        # 親はエスケープ
        $escParent = [System.Management.Automation.WildcardPattern]::Escape($parent)
        # 親の子配列を取得
        $childs = Get-ChildItem $escParent -File
        foreach ($child in $childs) {
            # 子にスクリプトを実行
            $name = Join-Path $parent $child.Name
            try {
                Invoke-Expression ("{0} `"{1}`" `"{2}`"{3}" -f $scr, $folder, $name, $argsall)
                if (0 -ne $LASTEXITCODE) {
                    exit -1
                }
            } catch {
                Write-Host (
                    '{0} {1} {2} 異常終了' -f (
                        ($_.InvocationInfo.PositionMessage -replace '\s+', ' '),
                        ($_.Exception.Message -replace '\s+', ' '),
                        $_.CategoryInfo.ToString()
                    )
                )
                throw New-Object Exception
            }
        }
        # 親の子配列を取得
        $childs = Get-ChildItem $escParent -Directory
        foreach ($child in $childs) {
            # 子にスクリプトを実行
            $name = Join-Path $parent $child.Name
            try {
                Invoke-Expression ("{0} `"{1}`" `"{2}`"{3}" -f $scr, $folder, $name, $argsall)
                if (0 -ne $LASTEXITCODE) {
                    exit -1
                }
            } catch {
                Write-Host (
                    '{0} {1} {2} 異常終了' -f (
                        ($_.InvocationInfo.PositionMessage -replace '\s+', ' '),
                        ($_.Exception.Message -replace '\s+', ' '),
                        $_.CategoryInfo.ToString()
                    )
                )
                throw New-Object Exception
            }
            # 子を親配列に追加
            $parents += @($name)
        }
    }
}
# 正常終了
exit 0
