﻿Clear-Host
$folder = 'C:\ChangeFlatFolderTest'
. .\changeFlatFolder\changeFlatFolder.ps1 $folder $folder $folder
if (0 -ne $LASTEXITCODE) {
    exit -1
}
Write-Host '正常終了'
exit 0
