Clear-Host
$project = 'C:\CreateSolutionTest\CreateSolutionTest.csproj'
. .\createSolution\createSolution.ps1 $project
if (0 -ne $LASTEXITCODE) {
    exit -1
}
Write-Host '正常終了'
exit 0
