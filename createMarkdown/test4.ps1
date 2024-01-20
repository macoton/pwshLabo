$val = $true
if (7 -le $PSVersionTable.PSVersion.Major) {
    [scriptblock]::Create(@'
$val21 = $val ? 1 : 0
'@
    ).Invoke()
}
function IIf {
    param (
        [scriptblock]$condition,
        [scriptblock]$returnTrue,
        [scriptblock]$returnFalse
    )
    if ($condition.Invoke()) {
        $returnTrue.Invoke()
    } else {
        $returnFalse.Invoke()
    }
}
$val22 = IIf { $val } { 1 } { 0 }
Write-Output $val
if (7 -le $PSVersionTable.PSVersion.Major) {
    Write-Output $val21
}
Write-Output $val22
$a = 1
