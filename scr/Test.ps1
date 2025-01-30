#!/usr/bin/env pwsh
[CmdletBinding()]
param (
    [Parameter(ValueFromRemainingArguments = $true)]$args
)
if ($null -ne $args) {
    throw
}

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms
$xamlPath = 'scr/Test.xaml'
# $xamlPath = 'scr/GrepToolGUI.xaml'

if (!(Test-Path $xamlPath)) {

    $form = [System.Windows.Forms.Form]::new()
    $form.Text = '入力項目'
    $form.Width = 400
    $form.Height = 300

    # パス
    $labelPath = [System.Windows.Forms.Label]::new()
    $labelPath.Text = 'パス'
    $labelPath.Top = 20
    $labelPath.Left = 10
    $form.Controls.Add($labelPath)

    $textBoxPath = [System.Windows.Forms.TextBox]::new()
    $textBoxPath.Name = 'path'
    $textBoxPath.Top = 20
    $textBoxPath.Left = 110
    $textBoxPath.Width = 250
    $textBoxPath.Text = '.'
    $form.Controls.Add($textBoxPath)

    # ワイルドカード
    $labelIncludes = [System.Windows.Forms.Label]::new()
    $labelIncludes.Text = 'ワイルドカード'
    $labelIncludes.Top = 60
    $labelIncludes.Left = 10
    $form.Controls.Add($labelIncludes)

    $textBoxIncludes = [System.Windows.Forms.TextBox]::new()
    $textBoxIncludes.Name = 'includes'
    $textBoxIncludes.Top = 60
    $textBoxIncludes.Left = 110
    $textBoxIncludes.Width = 250
    $textBoxIncludes.Text = '*.c *.h *.cpp'
    $form.Controls.Add($textBoxIncludes)

    # クラス
    $labelPattern1 = [System.Windows.Forms.Label]::new()
    $labelPattern1.Text = 'クラス'
    $labelPattern1.Top = 100
    $labelPattern1.Left = 10
    $form.Controls.Add($labelPattern1)

    $textBoxPattern1 = [System.Windows.Forms.TextBox]::new()
    $textBoxPattern1.Name = 'pattern1'
    $textBoxPattern1.Top = 100
    $textBoxPattern1.Left = 110
    $textBoxPattern1.Width = 250
    $textBoxPattern1.Text = ''
    $form.Controls.Add($textBoxPattern1)

    # メソッド
    $labelPattern2 = [System.Windows.Forms.Label]::new()
    $labelPattern2.Text = 'メソッド'
    $labelPattern2.Top = 140
    $labelPattern2.Left = 10
    $form.Controls.Add($labelPattern2)

    $textBoxPattern2 = [System.Windows.Forms.TextBox]::new()
    $textBoxPattern2.Name = 'pattern2'
    $textBoxPattern2.Top = 140
    $textBoxPattern2.Left = 110
    $textBoxPattern2.Width = 250
    $textBoxPattern2.Text = '\bmain\b'
    $form.Controls.Add($textBoxPattern2)

    # エンコード
    $labelEncoding = [System.Windows.Forms.Label]::new()
    $labelEncoding.Text = 'エンコード'
    $labelEncoding.Top = 180
    $labelEncoding.Left = 10
    $form.Controls.Add($labelEncoding)

    $textBoxEncoding = [System.Windows.Forms.TextBox]::new()
    $textBoxEncoding.Name = 'encoding'
    $textBoxEncoding.Top = 180
    $textBoxEncoding.Left = 110
    $textBoxEncoding.Width = 250
    $textBoxEncoding.Text = 'default'
    $form.Controls.Add($textBoxEncoding)

    # ボタン
    $button = [System.Windows.Forms.Button]::new()
    $button.Name = 'button'
    $button.Text = 'OK'
    $button.Top = 220
    $button.Left = 150
    $form.Controls.Add($button)

    $textBoxPath2 = $form.Controls | Where-Object { 'path' -eq $_.Name }
    $textBoxIncludes2 = $form.Controls | Where-Object { 'includes' -eq $_.Name }
} else {

    $xamlData = Get-Content $xamlPath -Raw -Encoding UTF8
    $reader = [System.Xml.XmlNodeReader]::new([xml]$xamlData)
    $form = [Windows.Markup.XamlReader]::Load($reader)
    $textBoxPath = $form.Controls | Where-Object { 'path' -eq $_.Name }
    $textBoxIncludes = $form.Controls | Where-Object { 'includes' -eq $_.Name }
}

$form.ShowDialog()

$xamlData = [System.Windows.Markup.XamlWriter]::Save($form)
Set-Content $xamlPath $xamlData -Encoding UTF8

Write-Host $local:MyInvocation.MyCommand.Path

exit 0
