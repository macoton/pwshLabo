function global:ReloadScript {
    param (

    )
    . $global:MyInvocationMyCommandPath
}

function global:PrintScript {
    param (

    )
    $global:MyInvocationMyCommandPath
    '{0:yyyyMMddHHmmss}' -f $global:MyInvocationMyCommandLastWriteTime
}

$global:MyInvocationMyCommandPath = $local:MyInvocation.MyCommand.Path
$global:MyInvocationMyCommandLastWriteTime = (Get-ItemProperty $global:MyInvocationMyCommandPath).LastWriteTime
PrintScript

Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Management-PowerShell

diskpart.exe

select vdisk file="D:\ubuntu-ja-14.04-desktop-amd64.vhd"

attach vdisk

select vdisk file="D:\Ubuntu.vdi"

attach vdisk
