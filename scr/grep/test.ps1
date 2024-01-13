function printVar {
    param (
        $name
    )
    $tmpVar = Invoke-Expression $name
    if (-not($tmpVar)) {
        $var = 'not set'
    } elseif ($tmpVar -is [string]) {
        $var = "'{0}'" -f $tmpVar
    } else {
        $var = $tmpVar
    }
    Write-Host ('{0}: {1}' -f $name, $var)
}
printVar '$local:MyInvocation.MyCommand.Path'
printVar '$script:MyInvocation.MyCommand.Path'
