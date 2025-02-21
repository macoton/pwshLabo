#!/usr/bin/env pwsh
[CmdletBinding()]
param (
    [Parameter(ValueFromRemainingArguments = $true)]$args
)
if ($null -ne $args) {
    throw
}

function GrepTool-Get-Help {
    param (
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    if ($null -ne $args) {
        throw
    }
    @'
名前
    GrepTool

使い方１
GrepTool-Get-ChildItem '.' ('*.c *.h *.cpp' -split ' ') |
GrepTool-Select-String '' '\bmain\b' 'default' |
GrepTool-Write-Output | Set-Clipboard

使い方２
GrepTool-Get-ChildItem '.' ('*.c *.h *.cpp' -split ' ') |
GrepTool-Select-String2 '' 'default' |
GrepTool-Write-Output2 | Set-Clipboard

'@
}

function GrepTool-Get-ChildItem {
    param (
        [string]$path,
        [array]$includes,
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    begin {
        $global:path = $path
        $global:includes = $includes
    } process {
        if ($null -ne $args) {
            throw
        }
        @(Get-ChildItem $path -Include $includes -File -Recurse)
    }
}

function GrepTool-Select-String {
    param (
        [string]$pattern1,
        [string]$pattern2,
        $encoding,
        [Parameter(ValueFromPipeline = $true)][System.IO.FileInfo]$item,
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    begin {
        $global:pattern1 = $pattern1
        $global:pattern2 = $pattern2
        $global:encoding = $encoding
    } process {
        if ($null -ne $args) {
            throw
        }
        $select1 = @()
        if ('' -ne $pattern1) {
            $select1 = @(Select-String $pattern1 $item -Encoding $encoding)
        }
        $select2 = @()
        if ('' -ne $pattern2) {
            $select2 = @(Select-String $pattern2 $item -Encoding $encoding)
        }
        if (('' -eq $pattern1 -or 0 -lt $select1.Count) -and
            ('' -eq $pattern2 -or 0 -lt $select2.Count)) {
            $select1 + $select2 | Sort-Object LineNumber | ForEach-Object { $_ | Add-Member NoteProperty 'Comment' '要調査' -PassThru }
        } else {
            $select1 + $select2 | Sort-Object LineNumber | ForEach-Object { $_ | Add-Member NoteProperty 'Comment' '対象外' -PassThru }
        }
    }
}

function GrepTool-Write-Output {
    param (
        $getTabString = { param($inputString) GrepTool-Get-TabString $inputString },
        [Parameter(ValueFromPipeline = $true)][Microsoft.PowerShell.Commands.MatchInfo]$item,
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    begin {
        "パス`t$global:path"
        "ワイルドカード`t$global:includes"
        "クラス`t$global:pattern1"
        "メソッド`t$global:pattern2"
        "エンコード`t$global:encoding"
        "ファイル名(行番号):`t内容`t備考"
    } process {
        if ($null -ne $args) {
            throw
        }
        "$($item.Path)($($item.LineNumber)):`t$(& $getTabString $item.Line)`t$($item.Comment)"
    } end {
        '終了'
    }
}

function GrepTool-Select-String2 {
    param (
        [string]$pattern1,
        $encoding,
        [Parameter(ValueFromPipeline = $true)][System.IO.FileInfo]$item,
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    begin {
        $global:pattern1 = $pattern1
        $global:encoding = $encoding
    } process {
        if ($null -ne $args) {
            throw
        }
        $select1 = @()
        if ('' -ne $pattern1) {
            $select1 = @(Select-String $pattern1 $item -Encoding $encoding)
        }
        $select1 | Sort-Object LineNumber
    }
}

function GrepTool-Write-Output2 {
    param (
        $getTabString = { param($inputString) GrepTool-Get-TabString $inputString },
        [Parameter(ValueFromPipeline = $true)][Microsoft.PowerShell.Commands.MatchInfo]$item,
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    begin {
        "パス`t$global:path"
        "ワイルドカード`t$global:includes"
        "マーク`t$global:pattern1"
        "エンコード`t$global:encoding"
        "ファイル名(行番号):`tマーク"
    } process {
        if ($null -ne $args) {
            throw
        }
        "$($item.Path)($($item.LineNumber)):`t$($item.matches.Value)"
    } end {
        '終了'
    }
}

function GrepTool-Get-TabString {
    param (
        $inputString,
        $tabSize = 4,
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    $outputString = ''
    $column = 0
    foreach ($char in $inputString.ToCharArray()) {
        if ($char -eq "`t") {
            $spacesToAdd = $tabSize - ($column % $tabSize)
            $outputString += ' ' * $spacesToAdd
            $column += $spacesToAdd
        } else {
            $outputString += $char
            $column++
        }
    }
    $outputString
}

Write-Host $local:MyInvocation.MyCommand.Path

exit 0
