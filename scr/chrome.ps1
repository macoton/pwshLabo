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

function global:Chrome {
    param (
        [switch]$edge,
        [switch]$cors,
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    if ($args) {
        throw
    }
    if (-not($edge)) {
        $path = 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'
    } else {
        $path = 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'
    }
    if (-not($cors)) {
        $userDataDir = $null
        $params = @()
    } else {
        $userDataDir = 'C:\tmp'
        $params = '--disable-web-security', ('--user-data-dir={0}' -f $userDataDir)
    }
    if ($null -ne $userDataDir) {
        New-Item $userDataDir -ItemType Directory 2>&1 > $null
    }
    Start-Process $path $params
}
