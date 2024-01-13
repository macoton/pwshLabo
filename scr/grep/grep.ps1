#!/usr/bin/env pwsh
[CmdletBinding()]
param (
    [Parameter(ValueFromRemainingArguments = $true)]$args
)
Set-PSDebug -Strict
if ($args) {
    throw
}

Write-Host $local:MyInvocation.MyCommand.paths

$global:grepOption = @{
    recurse = $false
    #recurse = $true
    startWords =
        '#if 0',
        '/\*',
        '"'
    endWords =
        '#endif',
        '\*/',
        '[^\\]"'
    fromWords =
        '[^\r\n]',
        '[^\r\n]',
        '[^\r\n]'
    toWords =
        ' ',
        ' ',
        ' '
}
{
    $global:grepOption += @{
        fromWords =
            '',
            '',
            ''
        toWords =
            '',
            '',
            ''
        testWords =
            'qqq',
            'qqq',
            'qqq'
    }
}

function global:Grep {
    param (
        [string[]]$input1s,
        [string[]]$input2s,
        [ref][string[][]]$outputs,
        [string[]]$paths,
        [string]$filter,
        [string[]]$includes,
        [string[]]$excludes,
        [switch]$recurse,        
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    if ($args) {
        throw
    }
    $children = Get-ChildItem $paths $filter -Include $includes -Exclude $excludes -Recurse:($recurse -or $global:grepOption['recurse'])
    $outputs.Value = @()
    foreach ($child in $children) {
        $output = @()
        foreach ($input1 in $input1s) {
            $content = Get-Content $child.FullName -Raw
            $out = [System.Text.StringBuilder]''
            for (;;) {
                $matchs = $content | Select-String $global:grepOption['startWords'] | Select-Object -First 1
                if (-not($matchs)) {
                    $tmpContent = $content
                    [void]$out.Append($tmpContent)
                    break
                }
                $index = 0
                foreach ($startWord in $global:grepOption['startWords']) {
                    if ($matchs.Matches[0].Captures[0].Value -match $startWord) {
                        break
                    }
                    $index++
                }
                $tmpIndex1 = $matchs.Matches[0].Captures[0].Index
                if (0 -lt $tmpIndex1) {
                    $tmpContent = $content.Substring(0, $tmpIndex1)
                    [void]$out.Append($tmpContent)
                    $content = $content.Substring($tmpIndex1, $content.Length - $tmpIndex1)
                }
                $matchs2 = $content | Select-String $global:grepOption['endWords'][$index] | Select-Object -First 1
                if (-not($matchs2)) {
                    $tmpContent = $content -replace
                        $global:grepOption['fromWords'][$index], $global:grepOption['ToWords'][$index]
                    [void]$out.Append($tmpContent)
                    break
                }
                $tmpIndex1 = $matchs2.Matches[0].Captures[0].Index +
                    $matchs2.Matches[0].Captures[0].Length
                if (0 -lt $tmpIndex1) {
                    $tmpContent = $content.Substring(0, $tmpIndex1) -replace
                        $global:grepOption['fromWords'][$index], $global:grepOption['ToWords'][$index]
                    [void]$out.Append($tmpContent)
                    $content = $content.Substring($tmpIndex1, $content.Length - $tmpIndex1)
                }
            }
            $content = [string]$out
            #
            $folder = Join-Path (Split-Path (Split-Path $child.FullName -Parent) -Parent) 'out'
            New-Item $folder -ItemType Directory 2>&1 > $null
            Set-Content (Join-Path $folder (split-path $child.FullName -Leaf)) $content
            #
            $contents = $content.Split("`r")
            $matchs = $contents | Select-String $input1
            foreach ($match in $matchs) {
                $output += ,('{0}({1},{2},{3})' -f $child.FullName, $match.LineNumber, ($match.Matches[0].Captures[0].Index + 1), $input1)
            }
        }
        if (0 -lt $output.Count) {
            $outputs.Value += ,$output
        }
    }
}

#$input1s = ,'\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'
$input1s = ,'\s+'
$input2s = ,''
$a = ,'a'
$b = 'a',
    ''
$outputs = @()
Grep $input1s $input2s ([ref]$outputs) (Join-Path 'scr' 'grep' 'in') '*.c'
$outputs
