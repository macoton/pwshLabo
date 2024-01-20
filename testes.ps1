Clear-Host
Set-StrictMode -Version 2.0
$a = @(1,2,3)
$b = @(1,2,3)
Write-Host ($a -eq $b)
Write-Host (($a -join ',') -eq ($b -join ','))
function CompElement {
    param (
        $aElement,
        $bElement,
        $length
    )
    $aLength = $aElement.Count
    $bLength = $bElement.Count
    if ($null -ne $length) {
        if ($length -lt $aLength) {
            $aLength = $length
        }
        if ($length -lt $bLength) {
            $bLength = $length
        }
    }
    $result = $bLength - $aLength
    if (0 -eq $result) {
        for ($cnt = 0; $cnt -lt $aLength; ++$cnt) {
            $result = $bElement[$cnt] - $aElement[$cnt]
            if (0 -ne $result) {
                break
            }
        }
    }
    return $result
}
$a = @(1,2,3,4)
$b = @(1,2,3)
$d = CompElement $a $b 4
Write-Host $d.GetType().Name
Write-Host $d
if (0 -eq $d) {
    '='
} elseif (0 -lt $d) {
    '<'
} else {
    '>'
}
