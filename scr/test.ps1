Set-PSDebug -Off
$strings = @("apple", "banana", "cherry", "date")
$regex = "(a|e|i|o|u)"
$matches = @()
foreach ($string in $strings) {
    if ($string -match $regex) {
        $matches += $Matches[0]
    }
}
$result = $matches -join ""
Write-Host $result
