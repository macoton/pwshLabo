Clear-Host
. .\createSolution\createSolution.ps1 C:\CreateSolutionTest\CreateSolutionTest.csproj C:\CreateSolutionTest\CreateSolutionTest.sln C:\CreateSolutionTest\CreateSolutionTest.sln
if (0 -ne $LASTEXITCODE) {
    exit -1
}
Write-Host '正常終了'
exit 0
