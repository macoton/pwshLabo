Clear-Host

$b = "`n" * 2
$c = "`n" * 2
$a = "Data: $b ${c}d"
Write-Host $a

$a = "Data: $("`n" * 2) $("`n" * 2)d"
Write-Host $a

$a = "Data: {0} {1}d" -f ("`n" * 2), ("`n" * 2)
Write-Host $a

$b = "`n" * 2
$c = "`n" * 2
$a = "Data: {0} {1}d" -f $b, $c
Write-Host $a

$d = @(
    ("`n" * 2),
    ("`n" * 2)
)
$a = "Data: {0} {1}d" -f $d
Write-Host $a
