#!/usr/bin/env pwsh
[CmdletBinding()]
param (
    [Parameter(ValueFromRemainingArguments = $true)]$args
)
if ($null -ne $args) {
    throw
}

. scr\GrepTool.ps1
GrepTool-Get-ChildItem '.' ('*.c *.h *.cpp' -split ' ') |
GrepTool-Select-String '' '\bmain\b' 'default' |
GrepTool-Write-Output | Set-Clipboard

Write-Host $local:MyInvocation.MyCommand.Path

exit 0
