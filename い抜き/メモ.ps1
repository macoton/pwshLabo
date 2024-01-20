Clear-Host
#$A = Read-Host 'Enter a string'
$A = @'
いなければ
[^い々〇〻\u3400-\u9FFF\uF900-\uFAFF]なければ
([^いし々〇〻\u3400-\u9FFF\uF900-\uFAFF])なければ
$1いなければ

います
[^い々〇〻\u3400-\u9FFF\uF900-\uFAFF]ます
([^いし々〇〻\u3400-\u9FFF\uF900-\uFAFF])ます
$1います

いません
[^い々〇〻\u3400-\u9FFF\uF900-\uFAFF]ません
([^いしき々〇〻\u3400-\u9FFF\uF900-\uFAFF])ません
$1いません

いる
[^い々〇〻\u3400-\u9FFF\uF900-\uFAFF]る
([^いせすなよ々〇〻\u3400-\u9FFF\uF900-\uFAFF]る)
$1いる

いれば
[^い々〇〻\u3400-\u9FFF\uF900-\uFAFF]れば
([^いけすあ々〇〻\u3400-\u9FFF\uF900-\uFAFF])れば
$1いれば
'@
$B = $A -split "`r`n"
$C = $B | Where-Object { $_ -ne "" }
$D = for ($i = 0; $i -lt $C.Count; $i += 4) {
    ,$C[$i..($i+3)]
}
$D += ,@("")
$E = $D.Clone()
$E = $E | Sort-Object

if (Compare-Object $D $E) {
    Write-Output "NG"
    Set-Clipboard -Value $E
} else {
    Write-Output "OK"
    Write-Output $E
}
