Clear-Host
# powershellで以下の処理をお願います
# 文字列を変数dataStrに設定
$dataStr = @'
います
[^い々〇〻\u3400-\u9FFF\uF900-\uFAFF]ます
([^いし々〇〻\u3400-\u9FFF\uF900-\uFAFF])ます
$1います

いなければ
[^い々〇〻\u3400-\u9FFF\uF900-\uFAFF]なければ
([^いし々〇〻\u3400-\u9FFF\uF900-\uFAFF])なければ
$1いなければ

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
# 変数dataStrを改行で分割し空行は無視し変数dataArysに設定
# 変数dataArysを4つ取り出し空行の要素を追加し2次元配列の変数inputDataに設定
# 余りがあれば空行の要素を要素が5になるまで追加し変数inputDataに設定
# 変数inputDataを配列の要素一つ目で並び変え変数outputDataに設定
# 変数inputDataと変数outputDataが同じ内容であればOKを出力し$outputDataを出力
# でなければNGを出力し$outputDataをクリップボードに出力
$dataArys = $dataStr -split "`n" | Where-Object {$_ -ne ""}
$inputData = @()
for ($i=0; $i -lt $dataArys.Count; $i+=4) {
    $row = @($dataArys[$i], $dataArys[$i+1], $dataArys[$i+2], $dataArys[$i+3])
    while ($row.Count -lt 5) {
        $row += ""
    }
    $inputData += ,@($row)
}
$outputData = $inputData | Sort-Object { $_[0] }
if (Compare-Object $inputData $outputData) {
    "NG"
    Set-Clipboard -Value $outputData
} else {
    "OK"
    $outputData
}
