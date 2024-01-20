class Test {
    [int]$int
    [string]$string
    [System.Text.StringBuilder]$sb
    [System.Collections.ArrayList]$arrayList
}
$test = [Test]::new()

'int'
$test.int = [int]::new()
$int = $test.int
$int += 123
$test.int

'string'
$test.string = [string]::new('')
$string = $test.string
$string += 'Alice'
#$string = 'Alice'
$test.string

'sb'
$test.sb = [System.Text.StringBuilder]::new()
$sb = $test.sb
$sb.Append('Alice')
#$sb = 'Alice'
$test.sb

'arrayList'
$test.arrayList = [System.Collections.ArrayList]::new()
$arrayList = $test.arrayList
$arrayList.Add('Alice')
$test.arrayList
