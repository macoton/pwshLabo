function test1 {
    param (
        $filter,
        $path,
        [switch]$recurse
    )
    $children = Get-ChildItem $path $filter -Recurse:$recurse
    $children | ForEach-Object {
        $raw = Get-Content $_.FullName -Raw
        if ($raw) {
            if ($matches = [regex]::Matches($raw, '([^\s]*異常終了)(.|\n)*?([^'']*異常終了)')) {
                foreach ($matche in $matches) {
                    '{0}({1}:{2}:{3}:{4}): ' -f $_.FullName, $matche.Groups[1].Index, $matche.Groups[1].Length, $matche.Groups[3].Index, $matche.Groups[3].Length
                    $matche.Groups[1].Value
                    $matche.Groups[3].Value
                    #Compare-Object -ReferenceObject $matche.Groups[1].Value.ToCharArray() -DifferenceObject $matche.Groups[3].Value.ToCharArray()
                    #$a = 1
                }
            }
        }
    }
}
test1 '*.ps1' '.' -recurse:$true
