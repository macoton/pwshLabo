Clear-Host
$folder = 'C:\ChangeFlatFolderTest'
. .\changeFlatFolder\createFolder.ps1 $folder 10 $folder
if (0 -ne $LASTEXITCODE) {
    exit -1
}
Write-Host '正常終了'
exit 0
