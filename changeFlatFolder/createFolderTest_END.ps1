Clear-Host
$folder = 'C:\ChangeFlatFolderTest'
if (Test-Path $folder -PathType Container) {
    Remove-Item $folder -Recurse -Force 2>&1 > $null
    if (-not($?)) {
        Write-Host '異常終了'
        exit -1
    }
}
Write-Host '正常終了'
exit 0
