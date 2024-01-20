function GetScriptFolder1 {
    param (
    )
    Split-Path $Global:MyInvocation.MyCommand.Path -Parent
}







function GetScriptFolder2 {
    param (
    )
    $PSScriptRoot
}
