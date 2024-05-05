#!/usr/bin/env pwsh
[CmdletBinding()]
param (
    [Parameter(ValueFromRemainingArguments = $true)]$args
)
if ($null -ne $args) {
    throw
}

function funcこれは上位から呼び出せる2 {
    Write-Output funcこれは上位から呼び出せた2
}

exit 0
