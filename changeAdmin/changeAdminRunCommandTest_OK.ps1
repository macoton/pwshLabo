. .\changeAdmin\ChangeAdminRunCommand.ps1
Write-Host ('$pwd.Path: {0}' -f $pwd.Path)
Read-Host
Set-Location '.\changeAdmin'
ChangeAdminRunCommand @'
Write-Host ('$pwd.Path: {0}' -f $pwd.Path)
Read-Host
'@
Set-Location '..'
