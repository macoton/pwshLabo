$texts = ''
foreach ($code in 1..0x7e) {
    $texts += "{0}`n" -f ([System.Text.Encoding]::UTF8.GetString($code))
}
Write-Output $texts | Set-Clipboard
