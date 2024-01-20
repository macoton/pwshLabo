Clear-Host
$project = 'C:\Users\macot\Source\Repos\vsLabo\AiRelay\AiRelay.csproj'
. .\createSolution\createSolution.ps1 $project -template winforms
if (0 -ne $LASTEXITCODE) {
    exit -1
}
Write-Host '正常終了'
exit 0
