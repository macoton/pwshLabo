#!/usr/bin/env pwsh
[CmdletBinding()]
param (
    [Parameter(ValueFromRemainingArguments = $true)]$args
)
if ($null -ne $args) {
    throw
}

# 実行前の定義済関数メソッド名称を取得
$beforeNames = @((Get-Item 'function:').Name) | Where-Object { $null -ne $_ }

# ドットソースと非ドットソースで呼び出す
function ds1 {
    function funcこれは上位から呼び出せる1 {
        Write-Output funcこれは上位から呼び出せた1
    }
}
. ds1
function notds1 {
    function funcこれは上位から呼び出せない1 {
        Write-Output funcこれは上位から呼び出せないはず1
    }
}
notds1
. ds\ds2.ps1
ds\notds2.ps1

# 実行後の定義済関数メソッド名称を取得
$afterNames = @((Get-Item 'function:').Name) | Where-Object { $null -ne $_ }

# 差分の定義済関数メソッド名称を取得
$diffNames = $afterNames | Where-Object { $beforeNames -notcontains $_ }

# 差分の定義済関数メソッド名称を表示
Write-Host ■■■■ 差分の定義済関数メソッド名称
$diffNames

# 試しに呼び出す
Write-Host ■■■■ 試しに呼び出す
funcこれは上位から呼び出せる1
try {
    funcこれは上位から呼び出せない1
} catch {}
funcこれは上位から呼び出せる2
try {
    funcこれは上位から呼び出せない2
} catch {}

# 差分の定義済関数メソッド名称を削除
$diffNames | ForEach-Object { Remove-Item ('function:{0}' -f $_) }

exit 0
