Clear-Host
$folder = 'C:\ChangeFlatFolderTest'
. .\changeFlatFolder\createFolder.ps1
if (0 -ne $LASTEXITCODE) {
    exit -1
}
Write-Host '正常終了'
exit 0
