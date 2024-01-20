#Get-Process -Name msedge | Where-Object {$_.MainWindowTitle -ne ""} | Select-Object MainWindowTitle
#Get-Process -Name chrome | Where-Object {$_.MainWindowTitle -ne ""} | Select-Object MainWindowTitle
$a = $null
$a = Get-Process -Name msedge | Where-Object {$_.MainWindowTitle -ne ""} | Select-Object MainWindowTitle
if ($null -eq $a) {
    $null
}
$a = Get-Process -Name chrome | Where-Object {$_.MainWindowTitle -ne ""} | Select-Object MainWindowTitle
if ($null -eq $a) {
    $null
}

0..9 | ForEach-Object { $_ }

[System.Math]::Pow(2, 3)
