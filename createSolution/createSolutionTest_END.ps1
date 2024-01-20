Clear-Host
$solutions = @(
    'C:\CreateSolutionTest\CreateSolutionTest.sln',
    'C:\CreateSolutionTest2\CreateSolutionTest2.sln'
)
foreach ($solution in $solutions) {
    $solutionFolder = Split-Path $solution -Parent
    if (Test-Path $solutionFolder -PathType Container) {
        Remove-Item $solutionFolder -Recurse -Force 2>&1 > $null
        if (-not($?)) {
            Write-Host '異常終了'
            exit -1
        }
    }
}
Write-Host '正常終了'
exit 0
