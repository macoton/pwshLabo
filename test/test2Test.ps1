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

. .\test\test2.ps1 .\test | ForEach-Object {
# . .\test\test2.ps1 .\*.ps1 | ForEach-Object {
    # if ('' -eq $_.bom -and 'utf8' -eq $_.encode) {
    if ('bom' -ne $_.bom -or 'utf8' -ne $_.encode) {
        Write-Host $_.File $_.bom $_.encode
    }
}

exit 0
