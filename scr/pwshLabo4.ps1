Set-PSDebug -Strict

if ($false) {
$children = Get-ChildItem 'C:\a5m2'
ValuesToArray ([ref]$children)
$children.Count
$children.GetType().Name
ValuesFromArray  ([ref]$children)
$children.GetType().Name

New-Item 'C:\testes' -ItemType 'Directory' 2>&1 > $null
Remove-Item 'C:\testes\testes'

$children = Get-ChildItem 'C:\testes'
ValuesToArray ([ref]$children)
$children.Count
$children.GetType().Name
ValuesFromArray ([ref]$children)
$children.GetType().Name

New-Item 'C:\testes\testes' -ItemType 'Directory'

$children = Get-ChildItem 'C:\testes'
ValuesToArray ([ref]$children)
$children.Count
$children.GetType().Name
ValuesFromArray ([ref]$children)
$children.GetType().Name
}

$clips = Get-Clipboard
ValuesToArray ([ref]$clips)
$clips.Count
$clips.GetType().Name
ValuesFromArray ([ref]$clips)
$clips.GetType().Name

exit 0

Get-StartApps | Where-Object { $_.AppID -eq 'Chrome' }

Get-StartApps | Where-Object { $_.AppID -eq 'Chrome' }

#Get-StartApps.GetType()
