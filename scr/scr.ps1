#!/usr/bin/env pwsh
[CmdletBinding()]
param (
    [Parameter(ValueFromRemainingArguments = $true)]$args
)
Set-PSDebug -Strict
if ($args) {
    throw
}

function global:RestScr {
    param (
        $path,
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    if (-not($path)) {
        $path = $global:MyInvocationMyCommandPath
    }
    if (-not(Test-Path $path -PathType Leaf)) {
        if (0 -lt ($global:needScrs -eq $path).Count) {
            Write-Host $path
            throw
        }
        return
    }
    . $path
}
Set-Alias StartScr RestScr
Set-Alias Scr RestScr

function global:OpenScr {
    param (
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    if ($args) {
        throw
    }
    Invoke-Item $global:MyInvocationMyCommandPath
}

function global:PrintScr {
    param (
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    if ($args) {
        throw
    }
    $global:MyInvocationMyCommandPath
    global:GetTimeStamp $global:MyInvocationMyCommandLastWriteTime
    '空き容量は{0:N1}GBです。' -f ((Get-Volume -DriveLetter C).SizeRemaining / 1GB)
}

function global:OpenSet {
    param (
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    if ($args) {
        throw
    }
    $user = $env:UserName
    $items = (
        'C:\git\pwshLabo\.vscode\settings.json',
        ('C:\Users\{0}\AppData\Roaming\Code\User\settings.json' -f $user),
        ('C:\Users\{0}\AppData\Roaming\Code\User\keybindings.json' -f $user)
    )
    foreach ($item in $items) {
        Invoke-Item $item
    }
}

function global:GetTimeStamp {
    param (
        $datetime,
        [switch]$short,
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    if ($args) {
        throw
    }
    if (-not($datetime)) {
        $datetime = Get-Date
    }
    if ($short) {
        $format = '{0:yyyyMMdd}'
    } else {
        $format = '{0:yyyyMMddHHmmss}'
    }
    return $format -f $datetime
}

function global:GetPath {
    param (
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    if ($args) {
        throw
    }
    return $env:Path -replace '\\?;', "`n"
}

function global:GetPath2 {
    param (
        [EnvironmentVariableTarget]$target,
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    if ($args) {
        throw
    }
    return [Environment]::GetEnvironmentVariable('Path', $target) -replace '\\?;', "`n";
}

Write-Host $local:MyInvocation.MyCommand.Path
$global:MyInvocationMyCommandPath = $local:MyInvocation.MyCommand.Path
$global:MyInvocationMyCommandPathParent = Split-Path $global:MyInvocationMyCommandPath -Parent
$global:MyInvocationMyCommandLastWriteTime = (Get-ItemProperty $global:MyInvocationMyCommandPath).LastWriteTime
$global:needScrs =
    $global:MyInvocationMyCommandPath,
    (Join-Path $global:MyInvocationMyCommandPathParent 'var.ps1'),
    (Join-Path $global:MyInvocationMyCommandPathParent 'values.ps1')
$global:readScrs =
    (Join-Path $global:MyInvocationMyCommandPathParent 'var.ps1'),
    (Join-Path $global:MyInvocationMyCommandPathParent 'values.ps1'),
    (Join-Path $global:MyInvocationMyCommandPathParent 'chrome.ps1'),
    # (Join-Path $global:MyInvocationMyCommandPathParent 'myDns.ps1'),
    # (Join-Path $global:MyInvocationMyCommandPathParent 'xrea.ps1'),
    # (Join-Path $global:MyInvocationMyCommandPathParent 'sub2.ps1'),
    # (Join-Path ($global:MyInvocationMyCommandPathParent, 'grep' -join '/') 'grep.ps1'),
    ('C:\git\private_pwshLabo\scr\scr.ps1')
PrintScr
foreach ($readScr in $global:readScrs) {
    StartScr $readScr
}
