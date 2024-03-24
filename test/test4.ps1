#!/usr/bin/env pwsh
[CmdletBinding()]
param (
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

$encoding = [Console]::OutputEncoding
[Console]::OutputEncoding = [System.Text.Encoding]::Default
$verDefault = winget search Microsoft.PowerShell
$verDefault
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$verUTF8 = winget search Microsoft.PowerShell
$verUTF8
[Console]::OutputEncoding = $encoding

$verDefault
$verUTF8

exit 0
