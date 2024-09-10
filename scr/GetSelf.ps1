#!/usr/bin/env pwsh
[CmdletBinding()]
param (
    [Parameter(ValueFromRemainingArguments = $true)]$args
)
if ($null -ne $args) {
    throw
}

function Get-Self-Ip {
    param (
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    if ($null -ne $args) {
        throw
    }
    $invokeWebRequests =
        'http://api.ipify.org/',
        'https://ipinfo.io/ip',
        'https://ipecho.net/plain',
        $null
        # 'https://domains.google.com/checkip', # 404
        # 'http://api.ipify.org/',
        # 'https://ipinfo.io/ip',
        # 'https://ipecho.net/plain',
        # 'https://checkip.amazonaws.com', # 改行が付く
        # 'ipaddr.show', # 改行が付く
        # 'http://httpbin.org/ip', # "origin"の要素を含むjson形式である
        # $null
    $invokeWebRequests | ForEach-Object {
        if ($null -ne $_) {
            $result = (Invoke-WebRequest $_).Content
        }
        if ($null -ne $result) {
            return
        }
}
    return $result
}
