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

function Function {
    param (

    )
}

function global:GlobalFunction {
    param (
        
    )   
}

exit 0
