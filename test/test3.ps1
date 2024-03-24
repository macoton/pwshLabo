#!/usr/bin/env pwsh
[CmdletBinding()]
param (
    [string]$path1 = 'function:*',
    [string]$base2 = $PWD,
    [switch]$remove,
    [Parameter(ValueFromRemainingArguments = $true)]$args
)
# 使い方
function Usage {
    Write-Host ('{0} [-path1] パス1 [-path2] パス2 [-remove]' -f $script:MyInvocation.MyCommand.Name)
}
# 余計な引き数が指定されていれば異常終了
if ($null -ne $args) {
    Write-Host '余計な引き数が指定されています異常終了'
    Usage
    exit -1
}

# パスがパス1かつスクリプトブロックファイルがパス2のアイテムを取得
$base2Temp = Join-Path $base2 ''
if (!(Test-Path $path1)) {
    Write-Host 'パス1が存在しません'
    Usage
    exit -1
}
$items = Get-Item $path1 |
Where-Object { $null -ne $_.ScriptBlock.File -and
    $base2Temp -eq $_.ScriptBlock.File.Substring(0, $base2Temp.Length) }
# 削除が指定されていれば削除
if ($remove) {
    $items | Remove-Item
# その他は表示
} else {
    $items
}

exit 0
