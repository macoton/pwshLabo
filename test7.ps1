Clear-Host
$file = 'b'
$scr = './test5.ps1 "'
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
$a = 1
Write-Host $file