class Test {
    hidden [string]$Name = "Test"
    [string]ToString() {
        return $this.Name
    }
}
$test = [Test]::new()
$test | Get-Member
