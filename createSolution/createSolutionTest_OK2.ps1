Clear-Host
$project = 'C:\CreateSolutionTest2\CreateSolutionTest\CreateSolutionTest.csproj'
$solutionFolder = 'C:\CreateSolutionTest2'
. .\createSolution\createSolution.ps1 $project $solutionFolder
if (0 -ne $LASTEXITCODE) {
    exit -1
}
$project2 = 'C:\CreateSolutionTest2\CreateSolutionTest2\CreateSolutionTest2.csproj'
. .\createSolution\createSolution.ps1 $project2 $solutionFolder winforms
if (0 -ne $LASTEXITCODE) {
    exit -1
}
Write-Host '正常終了'
exit 0
