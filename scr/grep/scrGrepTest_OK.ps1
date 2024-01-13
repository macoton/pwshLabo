#!/usr/bin/env pwsh
[CmdletBinding()]
param (
    [string]$path1 = 'scr/grep/in',
    [string]$path2 = 'scr/grep/out',
    [Parameter(ValueFromRemainingArguments = $true)]$args
)
Set-PSDebug -Strict
if ($args) {
    throw
}

Write-Host $local:MyInvocation.MyCommand.Path

$MyInvocationMyCommandPath = $local:MyInvocation.MyCommand.Path
$MyInvocationMyCommandPathParent = Split-Path $MyInvocationMyCommandPath -Parent
. (Join-Path $MyInvocationMyCommandPathParent 'scrGrepTest_var.ps1')

New-Item $path2 -ItemType Directory 2>&1 > $null
$index1 = 0
foreach ($startWord1 in $startWords) {
    $index2 = 0
    foreach ($startWord2 in $startWords) {
        $file1 = Join-Path $path1 ('test{0}{1}.c' -f $index1, $index2)
        $file1
        $file2 = Join-Path $path2 ('test{0}{1}.c' -f $index1, $index2)
        $file2
        Copy-Item $file1 $file2
        ++$index2
    }
    ++$index1
}
