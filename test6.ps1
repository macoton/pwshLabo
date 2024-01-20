Clear-Host
$file = 'a'
$scr = './test7.ps1 "b"" "d" "c e"'
try {
    Invoke-Expression $scr
} catch {
    Write-Host (
        '{0} {1} {2} 異常終了' -f (
            ($_.InvocationInfo.PositionMessage -replace '\s+', ' '),
            ($_.Exception.Message -replace '\s+', ' '),
            $_.CategoryInfo.ToString()
        )
    )
    throw New-Object Exception
}
write-host $file
