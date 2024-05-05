#!/usr/bin/env pwsh
[CmdletBinding()]
param (
    [Parameter(ValueFromRemainingArguments = $true)]$args
)
if ($null -ne $args) {
    throw
}

# スクリプトを再開
function RestScr {
    param (
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    if ($null -ne $args) {
        throw
    }
    # スクリプトを再開
    . $settingScr.scr.startScr
}
Set-Alias StartScr RestScr
Set-Alias Scr RestScr

# スクリプトを開く
function OpenScr {
    param (
        [switch]$all,
        [switch]$need,
        [switch]$read,
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    if ($null -ne $args) {
        throw
    }
    # スクリプトを開く
    $scrs = [System.Collections.ArrayList]::new()
    $scrs.Add($settingScr.scr.startScr) >$null
    if ($all) {
        $need = $true
        $read = $true
    }
    if ($need) {
        $scrs.AddRange($settingScr.scr.needScrs)
    }
    if ($read) {
        $scrs.AddRange($settingScr.scr.readScrs)
    }
    foreach ($scr in $scrs) {
        Invoke-Item $scr
    }
}

Write-Host $local:MyInvocation.MyCommand.Path

# 設定値
if (Test-Path variable:settingScr) {
    # 後始末処理
} else {
    # 開始処理
    $settingScr = @{}
}
if ($settingScr.ContainsKey('scr')) {
    # 後始末処理
} else {
    # 開始処理
    $settingScr.scr = @{}
}
# 本スクリプト
$settingScr.scr.startScr = $local:MyInvocation.MyCommand.Path
$scrParent = Split-Path $local:MyInvocation.MyCommand.Path -Parent
# 必要スクリプト群
$settingScr.scr.needScrs = [System.Collections.ArrayList]::new()
$settingScr.scr.needScrs.AddRange(@(
    (Join-Path $scrParent 'Init.ps1')
    (Join-Path $scrParent 'ConvertValue.ps1')
))
# 読み込みスクリプト群
$settingScr.scr.readScrs = [System.Collections.ArrayList]::new()
$settingScr.scr.readScrs.AddRange(@(
    (Join-Path $scrParent 'Chrome.ps1')
    (Join-Path $scrParent 'CheckBattery.ps1')
    (Join-Path $scrParent 'var.ps1')
))
# スクリプトを開始
$scrs = [System.Collections.ArrayList]::new()
$scrs.AddRange($settingScr.scr.needScrs)
$scrs.AddRange($settingScr.scr.readScrs)
foreach ($scr in $scrs) {
    . $scr
}

exit 0
