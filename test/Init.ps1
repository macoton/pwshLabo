#!/usr/bin/env pwsh
[CmdletBinding()]
param (
    [Parameter(ValueFromRemainingArguments = $true)]$args
)
if ($null -ne $args) {
    throw
}

Set-PSDebug -Strict
# Set-PSDebug -Off
Set-StrictMode -Version 2.0
# Set-StrictMode -Off
$global:ErrorActionPreference = 'Stop'

exit 0
