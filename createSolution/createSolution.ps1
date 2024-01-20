#!/usr/bin/pwsh
[CmdletBinding()]
param (
    $project,
    $solution,
    $template,
    [Parameter(ValueFromRemainingArguments=$true)]$args
)
# 使い方
function Usage {
    Write-Host ('{0} プロジェクト [ソリューション] [テンプレート]' -f $Script:MyInvocation.MyCommand.Name)
    Write-Host ''
    Write-Host '【機  能】'
    Write-Host "`tプロジェクトファイルからソリューションファイルを作成"
    Write-Host ''
    Write-Host '【引き数】'
    Write-Host "`tプロジェクト`t作成したいプロジェクトファイル"
    Write-Host "`tソリューション`t作成したいソリューションファイル"
    Write-Host "`tテンプレート`t作成したいテンプレート"
    Write-Host
    dotnet new --list 2>&1
}
# 余計な引き数が指定されていれば異常終了
if ($null -ne $args) {
    Write-Host '余計な引き数が指定されています異常終了'
    Usage
    exit -1
}
# プロジェクトが指定されていなければ異常終了
if ($null -eq $project) {
    Write-Host 'プロジェクトに指定されていません異常終了'
    Usage
    exit -1
}
$projectFolder = Split-Path $project -Parent
# ソリューションが指定されていなければプロジェクト設定
if ($null -eq $solution) {
    $solution = Join-Path $projectFolder ((Split-Path $projectFolder -Leaf) + '.sln')
# ソリューションに何も存在しなければ
# ソリューションにフォルダが存在すれば
} elseif (-not(Test-Path $solution) -or 
    (Test-Path $solution -PathType Container)) {
    $solution = Join-Path $solution ((Split-Path $solution -Leaf) + '.sln')
}
$solutionFolder = Split-Path $solution -Parent
if ($null -eq $template) {
    $template = 'console'
}
# プロジェクトに何も存在しなければ処理継続
if (-not(Test-Path $project)) {
    dotnet new $template -o $projectFolder -n (Split-Path $project -LeafBase) 2>&1 > $null
# プロジェクトにファイルが存在しなければ異常終了
} elseif (-not(Test-Path $project -PathType Leaf)) {
    Write-Host 'プロジェクトにファイルが存在しません異常終了'
    Usage
    exit -1
}
# ソリューションに何も存在しなければ処理継続
if (-not(Test-Path $solution)) {
    dotnet new sln -o $solutionFolder -n (Split-Path $solution -LeafBase) 2>&1 > $null
# ソリューションにファイルが存在しなければ異常終了
} elseif (-not(Test-Path $solution -PathType Leaf)) {
    Write-Host 'ソリューションにファイルが存在しません異常終了'
    Usage
    exit -1
}
# ソリューションにプロジェクトを追加
dotnet sln $solution add $project 2>&1 > $null
exit 0
