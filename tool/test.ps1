class Test {
    [string]$title
    [System.Diagnostics.Stopwatch[]]$sws
    [object[]]$elements
    [datetime]$startDate
    [datetime]$endDate
    Test() {
        $this.sws = ([System.Diagnostics.Stopwatch]::new())
        #$this.elements = @(0..999999)
        $this.elements = @(0..99)
    }
    [void]SwStart() {
        $this.sws[0].Start()
    }
    [void]SwStop() {
        $this.sws[0].Stop()
    }
    [void]PrintInfo() {
        Write-Host ('{0}: {1} seconds' -f $this.title, $this.sws[0].Elapsed.TotalSeconds)
    }
}

class IndexTest : Test {
    IndexTest() : base() {
    }
    [void]DoTest() {
        $this.SwStart()
        #$this.AccessElements( { Write-Host $this.elements[$count] } )
        $this.AccessElements( { ++$this.elements[$count] } )
        #$this.AccessElements( { Write-Host $this.elements[$count] } )
        $this.SwStop()
    }
}

class ElementTest : Test {
    ElementTest() : base() {
    }
    [void]DoTest() {
        $this.SwStart()
        #$this.AccessElements( { Write-Host $element } )
        $this.AccessElements( { ++$element } )
        #$this.AccessElements( { Write-Host $element } )
        $this.SwStop()
    }
}

class ForTest : IndexTest {
    ForTest() : base() {
    }
    [void]DoTest() {
        $this.title = 'for ($count = 0; $this.elements.Count -gt $count; ++$count)'
        ([IndexTest]$this).DoTest()
    }
    [void]AccessElements([scriptblock]$sb) {
        for ($count = 0; $this.elements.Count -gt $count; ++$count) {
            $sb.Invoke()
        }
    }
}

class ForEachTest : ElementTest {
    ForEachTest() : base() {
    }
    [void]DoTest() {
        $this.title = 'foreach ($element in $this.elements)'
        ([ElementTest]$this).DoTest()
    }
    [void]AccessElements([scriptblock]$sb) {
        foreach ($element in $this.elements) {
            $sb.Invoke()
        }
    }
}

class SwitchTest : ElementTest {
    SwitchTest() : base() {
    }
    [void]DoTest() {
        $this.title = 'switch ($this.elements)'
        ([ElementTest]$this).DoTest()
    }
    [void]AccessElements([scriptblock]$sb) {
        switch ($this.elements) {
            default {
                $sb.Invoke()
            }
        }
    }
}

class ForEachObjectTest : ElementTest {
    ForEachObjectTest() : base() {
    }
    [void]DoTest() {
        $this.title = '$this.elements | ForEach-Object'
        ([ElementTest]$this).DoTest()
    }
    [void]AccessElements([scriptblock]$sb) {
        $this.elements | ForEach-Object {
            $sb.Invoke()
        }
    }
}

$tests = (
    [ForTest]::new(),
    [ForEachTest]::new(),
    [SwitchTest]::new(),
    [ForEachObjectTest]::new()
)
foreach ($test in $tests) {
    $test.DoTest()
}
foreach ($test in $tests) {
    $test.PrintInfo()
}
