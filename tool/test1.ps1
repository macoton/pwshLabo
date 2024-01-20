function Caller {
    param (
        [Parameter(Mandatory=$true)][scriptblock]$sb,
        [Parameter(ValueFromRemainingArguments=$true)]$args
    )
    if ($null -ne $args) {
        return $false
    }
    $sb.Invoke()
    $true
}

Caller { Write-Host (Get-Date) }
