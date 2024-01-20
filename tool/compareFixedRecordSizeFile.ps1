function compareFixedRecordSizeFile {
    param (
        [Parameter(Mandatory=$true)][ref][byte[]]$refInBytes1,
        [Parameter(Mandatory=$true)][ref][byte[]]$refInBytes2,
        [int]$recordSize = 1,
        [string]$outfile1,
        [string]$outfile2,
        [switch]$length
    )
    $inRecord1 = [System.Math]::Ceiling($refInBytes1.Value.Count / $recordSize)
    $inRecord2 = [System.Math]::Ceiling($refInBytes2.Value.Count / $recordSize)
    $minInRecord = [System.Math]::Min($inRecord1, $inRecord2)
    $diffRecords = @()
    switch (0..($minInRecord - 1)) {
        Default {
            if (Compare-Object `
                $refInBytes1.Value[($_ * $recordSize)..($_ * $recordSize + $recordSize - 1)] `
                $refInBytes2.Value[($_ * $recordSize)..($_ * $recordSize + $recordSize - 1)]) {
                $diffRecords += ,($_)
            }
        }
    }
    $diffRecords
}

compareFixedRecordSizeFile `
    ([ref][System.IO.File]::ReadAllBytes('.\PrintPowerShellScriptRoot.ps1')) `
    ([ref][System.IO.File]::ReadAllBytes('.\PrintPowerShellVersion.ps1')) | Set-Clipboard

exit
    
/*
Compare-Object $refInBytes1 $refInBytes2 -IncludeEqual | ForEach-Object {
    switch ($_.SideIndicator) {
        '<=' {
            '<='
        }
        '==' {
            '=='
        }
        '=>' {
            '=>'
        }
        Default {
            'err'
        }
    }
}
*/
