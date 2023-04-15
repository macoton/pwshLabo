Clear-Host
$folder = 'C:\ProcessChildItemTest'
if (-not(Test-Path $folder)) {
    Copy-Item . $folder -Recurse -Force 2>&1 > $null
    if (-not($?)) {
        Write-Host '異常終了'
        exit -1
    }
}
Write-Host '正常終了'
exit 0
