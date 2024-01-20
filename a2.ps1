#!/usr/bin/env pwsh
[CmdletBinding()]
param (
    [Int32]$callingProcessId = $PID,
    [Int32]$level = 0,
    [Parameter(ValueFromRemainingArguments = $true)]$args
)
Set-PSDebug -Strict
if ($args) {
    throw
}
$typeDefinition = Get-Content 'a.cs' -Raw
Add-Type -TypeDefinition $typeDefinition

$map = $null
$scr = {
    param (
#        [ref]$name,
        [ref]$map
    )
#    Write-Host ('*{0}*' -f $name.Value)
    Write-Host ('*{0}*' -f $name)
    $map.Value = [MemoryMappedFile]::OpenFileMapping($null, $true, $name)
#    $map = [MemoryMappedFile]::OpenFileMapping($null, $true, $name)
}
$name = $callingProcessId
$map = [System.IntPtr]::Zero
#Invoke-Command $scr -ArgumentList ([ref]$name), ([ref]$map)
Invoke-Command $scr -ArgumentList ([ref]$map)
if ($map -eq [System.IntPtr]::Zero) {
    $scr = {
        param (
#            [ref]$name,
            [ref]$map
        )
#        Write-Host ('*{0}*' -f $name.Value)
        Write-Host ('*{0}*' -f $name)
        $map.Value = [MemoryMappedFile]::CreateFileMapping([System.IntPtr]::Zero, [System.IntPtr]::Zero, 0x04, 0, $size, $name)
#        $map = [MemoryMappedFile]::CreateFileMapping([System.IntPtr]::Zero, [System.IntPtr]::Zero, 0x04, 0, $size, $name)
    }
    $size = 1024
#    Invoke-Command $scr -ArgumentList ([ref]$name), ([ref]$map)
    Invoke-Command $scr -ArgumentList ([ref]$map)
}
if ($map -eq [System.IntPtr]::Zero) {
    throw ('Failed to create file mapping {0}' -f ($scr -replace "n'", ''))
} else {
    Write-Output ('Success {0} {1}' -f $map, ($scr -replace "n'", ''))
}

$maxLevel = 2
if ($maxLevel -gt $level) {
    Start-Process (Get-Process -Id $PID).Name '.\a.ps1', $callingProcessId, ($level + 1) -NoNewWindow
}
$local:MyInvocation.Line
1..5 | ForEach-Object {
    #Write-Host $PID
    #Get-Process -Id $PID | Select-Object -ExpandProperty Id | ForEach-Object { Get-Process -Id $_ }
    Start-Sleep 1
}

[MemoryMappedFile]::CloseHandle($map)
