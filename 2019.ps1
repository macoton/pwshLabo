&'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Visual Studio 2019.lnk'


Get-ChildItem ..\..\Users\macot\source\repos\vsLabo *.*proj -Recurse |
ForEach-Object {$_.FullName}

$p = '..\..\Users\macot\source\repos\vsLabo'
$p2 = $p
Clear-Host
$m1 = Measure-Command {
    $l2 = [System.IO.Path]::GetFullPath($p2).Length
    $r1 = (
        Get-ChildItem $p *.*proj -Recurse |
        ForEach-Object { $_.FullName.Substring($l2) }
    )
}
$m2 = Measure-Command {
    $r2 = (
        Get-ChildItem $p *.*proj -Recurse |
        ForEach-Object { [System.IO.Path]::GetRelativePath($p2, $_.FullName) }
    )
}
($m2 - $m1).TotalSeconds
$r1
$r2
Compare-Object $r1 $r2
[array]::Reverse($r2)$

$p = '..\..\Users\macot\source\repos\vsLabo'
$p2 = 'C:\'

Get-ChildItem $p *.*proj -Recurse |
ForEach-Object { $_.FullName }



$p = '..\..\Windows'





[System.IO.Path]::GetFullPath('..\..\Users\macot\source\repos\vsLabo').Length

Get-ChildItem ..\..\Users\macot\source\repos\vsLabo *.*proj -Recurse | Select-Object -ExpandProperty FullName



'{0}\..\..\Users\macot\source\repos\vsLabo' -f (Get-Location)
