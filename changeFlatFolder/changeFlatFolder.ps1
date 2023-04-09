#!/usr/bin/pwsh
[CmdletBinding()]
param (
    $folder,
    $log,
    [switch]$undo,
    [Parameter(ValueFromRemainingArguments=$true)]$args
)
# 使い方
function Usage {
    Write-Host ('{0} フォルダ [ログファイル] [-undo]' -f $Script:MyInvocation.MyCommand.Name)
    Write-Host ''
    Write-Host '【機  能】'
    Write-Host "`tフォルダの２階層目以下のファイルやフォルダを１階層目に移動"
    Write-Host ''
    Write-Host '【引き数】'
    Write-Host "`tフォルダ`t作成したいフォルダ"
    Write-Host "`tログファイル`t作成したいログファイル"
    Write-Host ("`tundo`t{0} を取り消したい時に使用" -f $Script:MyInvocation.MyCommand.Name)
    Write-Host ''
    Write-Host '【その他】'
    Write-Host ("`tログファイルを指定しないと{0}になる" -f (Join-Path 'フォルダ' ($Script:MyInvocation.MyCommand.Name + '.log')))
    Write-Host "`tundoを指定しないと２階層目以下のファイルやフォルダを１階層目に移動"
    Write-Host "`tundoを指定すると１階層目のファイルやフォルダを２階層目以下に移動（undoを指定しない処理の反対）"
}
# 余計な引き数が指定されていれば異常終了
if ($null -ne $args) {
    Write-Host '余計な引き数が指定されています異常終了'
    Usage
    exit -1
}
# フォルダが指定されていなければ異常終了
if ($null -eq $folder) {
    Write-Host 'フォルダが指定されていません異常終了'
    Usage
    exit -1
}
# ログファイルが指定されていなければデフォルト設定
if ($null -eq $log) {
    $log = Join-Path $folder ($Script:MyInvocation.MyCommand.Name + '.log')
}
# フォルダにフォルダが存在しなければ異常終了
if (-not(Test-Path $folder -PathType Container)) {
    Write-Host 'フォルダにフォルダが存在しません異常終了'
    Usage
    exit -1
}
# undoを指定しない場合
if (-not($undo)) {
    # ログファイルに何かが存在すれば異常終了
    if (Test-Path $log) {
        Write-Host 'ログファイルに何かが存在します異常終了'
        Usage
        exit -1
    }
    # ログファイルにヘッダー出力
    Add-Content $log -Value 'from,to'
    # フォルダの２階層目以下のファイルやフォルダを１階層目に移動
    for (; ; ) {
        $continue = $false
        $childItems = Get-ChildItem $folder -Directory
        foreach ($childItem in $childItems) {
            $folder2 = Join-Path $folder $childItem.Name
            $childItems2 = Get-ChildItem $folder2
            foreach ($childItem2 in $childItems2) {
                $nameext2 = $childItem2.Name
                $ext2 = $childItem2.Extension
                $name2 = $nameext2.Substring(0, $nameext2.Length - $ext2.Length)
                $cnt = 1
                $nameext = '{0}{1}' -f $name2, $ext2
                while (Test-Path (Join-Path $folder $nameext)) {
                    ++$cnt
                    $nameext = '{0} ({2}){1}' -f $name2, $ext2, $cnt
                }
                Write-Host ('{0} を {1} に移動' -f (Join-Path $folder2 $nameext2), (Join-Path $folder $nameext))
                Move-Item (Join-Path $folder2 $nameext2) (Join-Path $folder $nameext)
                # ログファイルにディテール出力
                Add-Content $log -Value (((Join-Path $folder2 $nameext2), (Join-Path $folder $nameext)) -join ',')
                $continue = $true
            }
        }
        if (-not($continue)) {
            break
        }
    }
# undoを指定する場合
} else {
    # ログファイルにファイルが存在しなければ異常終了
    if (-not(Test-Path $log -PathType Leaf)) {
        Write-Host 'ログファイルにファイルが存在しません異常終了'
        Usage
        exit -1
    }
    # フォルダの１階層目のファイルやフォルダを２階層目以下に移動
    $csvs = Import-Csv $log
    [array]::Reverse($csvs)
    foreach ($csv in $csvs) {
        Write-Host ('{0} を {1} に移動' -f $csv.to, $csv.from)
        Move-Item $csv.to $csv.from
    }
    # ログファイルを削除
    Remove-Item $log -Force 2>&1 > $null
    if (-not($?)) {
        Write-Host 'ログファイルが削除できません異常終了'
        Usage
        exit -1
    }
}
# 正常終了
exit 0
