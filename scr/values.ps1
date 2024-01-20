#!/usr/bin/env pwsh
[CmdletBinding()]
param (
    [Parameter(ValueFromRemainingArguments = $true)]$args
)
Set-PSDebug -Strict
if ($args) {
    throw
}

function global:ValuesToArray {
    param (
        [ref]$values,
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    if ($args) {
        throw
    }
    if (-not($values.Value)) {
        $values.Value = @()
    } elseif (-not($values.Value -is [array])) {
        $values.Value = ,$values.Value[0]
    }
}

function global:ValuesFromArray {
    param (
        [ref]$values,
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    if ($args) {
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
