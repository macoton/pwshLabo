

Get-Process -IncludeUserName | Where-Object {$_.MainWindowTitle -ne ""} | Select-Object -Property *
