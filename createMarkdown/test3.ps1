
function Test2 {
    param (
        $Path
    )
    $Path *= 2
}
function Test3 {
    param (
        [ref]$Path
    )
    $Path.Value *= 2
}
function Test-Path2 {
    param (
        $Path
    )
    if ($Path.GetType() -ne ([ref]'').GetType()) {
        Write-Output $Path.GetType().Name
        Write-Output $Path
    } else {
        Write-Output $Path.GetType().Name
        Write-Output $Path.Value.GetType().Name
        Write-Output $Path.Value
    }
    #$false
}
Clear-Host
$a = 'qqq'
Test2 $a
$a
Test3 ([ref]$a)
$a
$path = 'aaa'
Test-Path2 $path
Test-Path2 ([ref]$path)
#$a = [ref]$path
#Test-Path2 ([ref]$a)
