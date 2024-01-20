function open {
    param (
        $filter
    )
}
function find {
    param (
        $path,
        $filter,
        $no,
        $condition,
        $return,
        [switch]$recurse
    )
    switch ($no) {
        $null {
            Get-ChildItem $path $filter -Recurse:$recurse | ForEach-Object { (& $condition) ? (& $return) : @( ) }
        }
        default {
            Get-ChildItem $path $filter -Recurse:$recurse | Where-Object { & $condition } | ForEach-Object { & $return }
        }
    }
}
Clear-Host



$time = (Get-Date).AddDays(-5)
$path = '.'
$filter = '*.ps1'
foreach ($no in ($null, 1)) {
    $a = Measure-Command {
        $b = find $path $filter $no { $time -lt $_.LastWriteTime } { ,($_.FullName, $_.LastWriteTime) } -recurse:$true
        $c = find $path $filter $no { $time -lt $_.LastWriteTime } { @{ FullName = $_.FullName; LastWriteTime = $_.LastWriteTime } } -recurse:$true
        $d = find $path $filter $no { $time -lt $_.LastWriteTime } { $_.FullName } -recurse:$true
        $e = find $path $filter $no { $time -lt $_.LastWriteTime } { 1 } -recurse:$true
    }
    $a.TotalSeconds
}
$f = 1


