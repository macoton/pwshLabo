$file = 'C:\Users\macot\OneDrive\デスクトップ\pwshLabo\awsCloudShell\createTextFile.ps1'
$texts = Get-Content $file
$no = 1
$no2 = 1
$refno2 = [ref]$no2
$funcs = @(
    {
        Write-Output $texts2
        $no = 2
        $refno2.Value = 2
    },
    {
        Write-Output @"
            $texts2
"@
        $no = 2
        $refno2.Value = 2
    },
    {
        Write-Output @"
            $($texts2 -join "`r`n")
"@
        $no = 2
        $refno2.Value = 2
    }
)

$texts2 = $texts
#$texts2 = @()

$funcs[$no].Invoke()
Write-Output $no
Write-Output $no2
