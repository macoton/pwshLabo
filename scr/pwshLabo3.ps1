function ReloadScript {
    param (

    )
    . $MyInvocationMyCommandPath
}

function PrintScript {
    param (

    )
    $MyInvocationMyCommandPath
    '{0:yyyyMMddHHmmss}' -f $MyInvocationMyCommandLastWriteTime
}

$MyInvocationMyCommandPath = $local:MyInvocation.MyCommand.Path
$MyInvocationMyCommandLastWriteTime = (Get-ItemProperty $MyInvocationMyCommandPath).LastWriteTime
PrintScript
