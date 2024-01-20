Clear-Host
. .\createTextFile\createTextFile.ps1 .\createTextFile\createTextFileTest_OK2 | Set-Clipboard
if (0 -ne $LASTEXITCODE) {
    exit -1
}
Write-Host '正常終了'
exit 0
