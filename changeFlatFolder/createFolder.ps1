#!/usr/bin/pwsh
[CmdletBinding()]
param (
    $folder,
    $length,
    [Parameter(ValueFromRemainingArguments=$true)]$args
)
# 使い方
function Usage {
    Write-Host ('{0} フォルダ パス長さ' -f $Script:MyInvocation.MyCommand.Name)
    Write-Host ''
    Write-Host '【機  能】'
    Write-Host "`tフォルダの配下にパス長さ以上のファイルやフォルダを作成"
    Write-Host ''
    Write-Host '【引き数】'
    Write-Host "`tフォルダ`t作成したいフォルダ"
    Write-Host "`tパス長さ`t作成したいパス長さ"
}
# 余計な引き数が指定されていれば異常終了
if ($null -ne $args) {
    Write-Host '余計な引き数が指定されています異常終了'
    Usage
    exit -1
}
# フォルダが指定されていなければ異常終了
if ($null -eq $folder) {
    Write-Host 'フォルダに指定されていません異常終了'
    Usage
    exit -1
}
# パス長さが指定されていなければデフォルト設定
if ($null -eq $length) {
    $length = 300
# パス長さが32ビット整数値以外が指定されていれば異常終了
} elseif ($length.GetType().Name -ne 'Int32') {
    Write-Host 'パス長さに32ビット整数値以外が指定されています異常終了'
    Usage
    exit -1
}
# 設定値
$names = @{
    file = 'myfile.txt'
    folder = 'myfolder'
}
# フォルダに何も存在しなければ処理継続
if (-not(Test-Path $folder)) {
    # フォルダを作成
    Write-Host ('{0} 作成' -f $folder)
    New-Item $folder -type directory 2>&1 > $null
# フォルダにフォルダが存在しなければ異常終了
} elseif (-not(Test-Path $folder -PathType Container)) {
    Write-Host 'フォルダにフォルダが存在しません異常終了'
    Usage
    exit -1
}
# フォルダの配下にファイルやフォルダを作成
while ($length -gt $folder.Length) {
    $file = Join-Path $folder $names.file
    if (-not(Test-Path $file)) {
        Write-Host ('{0} 作成' -f $file)
        New-Item $file -type file 2>&1 > $null
    }
    $folder = Join-Path $folder $names.folder
    if (-not(Test-Path $folder)) {
        Write-Host ('{0} 作成' -f $folder)
        New-Item $folder -type directory 2>&1 > $null
    }
}
# 正常終了
exit 0
