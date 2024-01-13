#!/usr/bin/env pwsh
[CmdletBinding()]
param (
    [Parameter(ValueFromRemainingArguments = $true)]$args
)
Set-PSDebug -Strict
if ($args) {
    throw
}

Write-Host $local:MyInvocation.MyCommand.Path
