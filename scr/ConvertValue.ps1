#!/usr/bin/env pwsh
[CmdletBinding()]
param (
    [Parameter(ValueFromRemainingArguments = $true)]$args
)
if ($null -ne $args) {
    throw
}

function Convert-Value-ToArray {
    param (
        [ref]$values,
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    if ($null -ne $args) {
        throw
    }
    if ($null -eq $values.Value) {
        $values.Value = @()
    } elseif ($values.Value -isnot [array]) {
        $values.Value = ,$values.Value[0]
    }
}

function Convert-Value-FromArray {
    param (
        [ref]$values,
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    if ($null -ne $args) {
        throw
    }
    switch ($values.Value.Count) {
        0 {
            $values.Value = $null
        } 1 {
            $values.Value = $values.Value[0]
        }
    }
}

Write-Host $local:MyInvocation.MyCommand.Path

exit 0
