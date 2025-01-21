#!/usr/bin/env pwsh
[CmdletBinding()]
param (
    [Parameter(ValueFromRemainingArguments = $true)]$args
)
if ($null -ne $args) {
    throw
}

function Tool-Test-FindItem {
    param (
        [string]$path,
        [array]$items,
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    if ($null -ne $args) {
        throw
    }
    Get-ChildItem $path -Include $items -File -Recurse
}

function Tool-Test-GrepWord {
    param (
        [string]$classes,
        [string]$members,
        [Parameter(ValueFromPipeline = $true)][System.IO.FileInfo]$item,
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    process {
        if ($null -ne $args) {
            throw
        }
        $s1 = Select-String $classes $item
        $s2 = Select-String $members $item
        if (0 -lt $s1.Count -and 0 -lt $s2.Count) {
            $s1
            $s2
        }
    }
}

function Tool-Test-OutData {
    param (
        [Parameter(ValueFromPipeline = $true)][Microsoft.PowerShell.Commands.MatchInfo]$item,
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    process {
        if ($null -ne $args) {
            throw
        }
        "$($item.Path)($($item.LineNumber)): $($item.Line)"
        # "$($_.Path)($($_.LineNumber)): $($_.Line)"
    }
}

Write-Host $local:MyInvocation.MyCommand.Path

exit 0
