Clear-Host
$folder = 'C:\ProcessChildItemTest'
. .\processChildItem\processChildItem.ps1 $folder -args -container | Set-Clipboard
if (0 -ne $LASTEXITCODE) {
    exit -1
}
Write-Host '正常終了'
exit 0
