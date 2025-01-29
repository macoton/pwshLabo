#!/usr/bin/env pwsh
[CmdletBinding()]
param (
    [Parameter(ValueFromRemainingArguments = $true)]$args
)
if ($null -ne $args) {
    throw
}

Add-Type -AssemblyName PresentationFramework

$form = New-Object System.Windows.Forms.Form
$form.Text = '入力項目'
$form.Width = 400
$form.Height = 300

# パス
$labelPath = New-Object System.Windows.Forms.Label
$labelPath.Text = 'パス'
$labelPath.Top = 20
$labelPath.Left = 10
$form.Controls.Add($labelPath)

$textBoxPath = New-Object System.Windows.Forms.TextBox
$textBoxPath.Top = 20
$textBoxPath.Left = 110
$textBoxPath.Width = 250
$textBoxPath.Text = '.'
$form.Controls.Add($textBoxPath)

# ワイルドカード
$labelIncludes = New-Object System.Windows.Forms.Label
$labelIncludes.Text = 'ワイルドカード'
$labelIncludes.Top = 60
$labelIncludes.Left = 10
$form.Controls.Add($labelIncludes)

$textBoxIncludes = New-Object System.Windows.Forms.TextBox
$textBoxIncludes.Top = 60
$textBoxIncludes.Left = 110
$textBoxIncludes.Width = 250
$textBoxIncludes.Text = '*.c *.h *.cpp'
$form.Controls.Add($textBoxIncludes)

# クラス
$labelPattern1 = New-Object System.Windows.Forms.Label
$labelPattern1.Text = 'クラス'
$labelPattern1.Top = 100
$labelPattern1.Left = 10
$form.Controls.Add($labelPattern1)

$textBoxPattern1 = New-Object System.Windows.Forms.TextBox
$textBoxPattern1.Top = 100
$textBoxPattern1.Left = 110
$textBoxPattern1.Width = 250
$textBoxPattern1.Text = ''
$form.Controls.Add($textBoxPattern1)

# メソッド
$labelPattern2 = New-Object System.Windows.Forms.Label
$labelPattern2.Text = 'メソッド'
$labelPattern2.Top = 140
$labelPattern2.Left = 10
$form.Controls.Add($labelPattern2)

$textBoxPattern2 = New-Object System.Windows.Forms.TextBox
$textBoxPattern2.Top = 140
$textBoxPattern2.Left = 110
$textBoxPattern2.Width = 250
$textBoxPattern2.Text = '\bmain\b'
$form.Controls.Add($textBoxPattern2)

# エンコード
$labelEncoding = New-Object System.Windows.Forms.Label
$labelEncoding.Text = 'エンコード'
$labelEncoding.Top = 180
$labelEncoding.Left = 10
$form.Controls.Add($labelEncoding)

$textBoxEncoding = New-Object System.Windows.Forms.TextBox
$textBoxEncoding.Top = 180
$textBoxEncoding.Left = 110
$textBoxEncoding.Width = 250
$textBoxEncoding.Text = 'default'
$form.Controls.Add($textBoxEncoding)

# ボタン
$button = New-Object System.Windows.Forms.Button
$button.Text = 'OK'
$button.Top = 220
$button.Left = 150
$button.Add_Click({

    . scr\GrepTool.ps1
    GrepTool-Get-ChildItem $textBoxPath.Text ($textBoxIncludes.Text -split ' ') |
    GrepTool-Select-String $textBoxPattern1.Text $textBoxPattern2.Text $textBoxEncoding.Text |
    GrepTool-Write-Output | Set-Clipboard

    [System.Windows.MessageBox]::Show('Clipboard copied!')
})
$form.Controls.Add($button)
$form.ShowDialog()

Write-Host $local:MyInvocation.MyCommand.Path

exit 0
