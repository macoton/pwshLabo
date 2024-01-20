[CmdletBinding()]
param(
    $folder,
    [array]$a,
    [switch]$undo
    #[parameter(ValueFromRemainingArguments=$true)]$others
)
$q = ''
Write-Host $PSBoundParameters.Count
Write-Host $folder
Write-Host $undo
