$groups = ,@() * 3
Get-ChildItem './*.ps1' -Recurse | ForEach-Object {
    $index = $_.FullName -match 'Test' ? 2 : 0
    if (0 -eq $index) {
        $raw = Get-Content $_.FullName -Raw
        $index = $raw -match "^#!/usr/bin/pwsh`r`n" ? 1 : 0
    }
    $groups[$index] += ,$_.FullName
    #$groups[$index] += ,$_
}
#{
#    0..($groups.Length - 1) | ForEach-Object {
#        $_
#        $groups[$_] | ForEach-Object {
#            $_.FullName
#        }
#    }
#} | Export-Clixml '.\processes.xml'

function ConvertTo-Json {
    param (
        [ref]$ref
    )
    if ($null -eq $ref) {
        ConvertTo-Json ([ref]$input)
        return
    }
    $ret = ''
    #Write-Host $ref.Value.GetType().Name
    switch ($ref.Value.GetType().Name) {
        'ArrayListEnumeratorSimple' {
            $a = 1
        }
        'Object[]' {
            $ret += '[ '
            $first = $true
            0..($ref.Value.Length - 1) | ForEach-Object {
                if ($first) {
                    $first = $false
                } else {
                    $ret += ', '
                }
                $ret += ConvertTo-Json ([ref]$ref.Value[$_])
            }
            $ret += ' ]'
        }
        'Hashtable' {
            $ret += '{ '
            $first = $true
            $ref.Value.Keys | ForEach-Object {
                if ($first) {
                    $first = $false
                } else {
                    $ret += ', '
                }
                $ret += '"{0}": {1}' -f $_, (ConvertTo-Json ([ref]$ref.Value[$_]))
            }
            $ret += ' }'
        }
        'String' {
            $ret += '"{0}"' -f $ref.Value
        }
        default {
            $ret += $ref.Value
        }
    }
    return $ret
}

#ConvertTo-Json ([ref]1)
#ConvertTo-Json ([ref]'1')
#ConvertTo-Json ([ref]@(1, '2'))
#ConvertTo-Json ([ref]@{a = 'b'; c = 0xd})

#ConvertTo-Json ([ref]$groups) | Out-File '.\processes.json'

$groups | ConvertTo-Json | Out-File '.\processes.json'

#$groups | ConvertTo-Json -Depth 99 | Out-File '.\processes.json'

#ConvertFrom-Markdown

#$groups | Export-Clixml '.\processes.xml'

#$tools = $ps1 | Where-Object { $raw = Get-Content $_.FullName -Raw; $raw -match "^#!/usr/bin/pwsh`r`n" }

        
