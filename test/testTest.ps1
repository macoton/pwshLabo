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

function If-Then-Else {
    param (
        $if,
        $item,
        $then,
        $else,
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    if ($null -ne $args) {
        throw
    }
    if (& $if $item) {
        if ($null -ne $then) {
            & $then $item
        }
    } else {
        if ($null -ne $else) {
            & $else $item
        }
    }
}

function If-Then {
    param (
        $if,
        $item,
        $then,
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    if ($null -ne $args) {
        If-Then-Else $if $item $then $null @args
    } else {
        If-Then-Else $if $item $then
    }
}

function If-Else {
    param (
        $if,
        $item,
        $else,
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    if ($null -ne $args) {
        If-Then-Else $if $item $null $else @args
    } else {
        If-Then-Else $if $item $null $else
    }
}

$test = {
    param (
        $item
    )
    return Test-Path $item
}
$removeAfterGet = {
    param (
        $item
    )
    Get-Item $item
    Remove-Item $item
}
$remove = {
    param (
        $item
    )
    Remove-Item $item
}

If-Then $test function:Function $removeAfterGet
If-Then $test function:GlobalFunction $removeAfterGet
. .\test\test.ps1
If-Then $test function:Function $removeAfterGet
If-Then $test function:GlobalFunction $removeAfterGet

If-Then $test function:Function $removeAfterGet
If-Then $test function:GlobalFunction $removeAfterGet
.\test\test.ps1
If-Then $test function:Function $removeAfterGet
If-Then $test function:GlobalFunction $removeAfterGet

If-Then-Else $test function:Usage $remove
If-Then-Else $test function:If-Then $remove
If-Then-Else $test function:If-Else $remove
If-Then-Else $test function:If-Then-Else $remove

return 0
