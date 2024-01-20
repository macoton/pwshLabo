[CmdletBinding()]
param (
    $file,
    [Parameter(ValueFromRemainingArguments=$true)]$args
)
# 使い方
function Usage {
    Write-Host ('{0} 指定ファイル' -f $Script:MyInvocation.MyCommand.Name)
    Write-Host ''
    Write-Host '【機  能】'
    Write-Host "`t指定ファイルを作成するcatコマンドを作成"
    Write-Host ''
    Write-Host '【引き数】'
    Write-Host "`t指定ファイル`tファイル名"
}
# 余計な引き数が指定されていれば異常終了
if ($null -ne $args) {
    Write-Host '余計な引き数が指定されています異常終了'
    Usage
    exit -1
}
# 指定ファイルが指定されていなければ異常終了
if ($null -eq $file) {
    Write-Host '指定ファイルに指定されていません異常終了'
    Usage
    exit -1
}
# 名前
$leaf = Split-Path $file -Leaf
# 内容
$eof = 'EOF'
$texts = Get-Content $file
for ($cnt = 0; $cnt -lt $texts.Count; ++$cnt) {
    while ($texts[$cnt].Length -ge $eof.Length -and $texts[$cnt].Substring(0, $eof.Length) -eq $eof) {
        $eof = '{0}F' -f $eof
    }
}
# catコマンドを作成
Write-Output @"
cat << '$eof' > $leaf
$($texts -join "`r`n")
$eof
"@
# 正常終了
exit 0
