Write-Host ('$Global:MyInvocation.MyCommand.Path={0}' -f $Global:MyInvocation.MyCommand.Path)
Write-Host ('$MyInvocation.MyCommand.Path={0}' -f $MyInvocation.MyCommand.Path)
function FunctionName {
    param (
    )
    Write-Host ('$Global:MyInvocation.MyCommand.Path={0}' -f $Global:MyInvocation.MyCommand.Path)
    Write-Host ('$MyInvocation.MyCommand.Path={0}' -f $MyInvocation.MyCommand.Path)
}
