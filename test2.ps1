function func2 {
    param (
    )
    func3
}
function func3 {
    Write-Host ('$Global:MyInvocation.MyCommand.Path={0}' -f $Global:MyInvocation.MyCommand.Path)
    Write-Host ('$MyInvocation.MyCommand.Path={0}' -f $MyInvocation.MyCommand.Path)
}
func3
