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

$mapName = "MySharedMemory"
$mapSize = 1024
$mapFile = New-Object System.IO.MemoryMappedFiles.MemoryMappedFile($mapName, $mapSize, [System.IO.MemoryMappedFiles.MemoryMappedFileAccess]::ReadWrite, [System.IO.MemoryMappedFiles.MemoryMappedFileOptions]::None, [System.Security.AccessControl.MemoryMappedFileSecurity]::new(), [System.IO.HandleInheritability]::None)
$mapView = $mapFile.CreateViewAccessor()

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

$mapView.Dispose()
$mapFile.Dispose()
