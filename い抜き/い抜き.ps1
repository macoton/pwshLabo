Clear-Host
# 文字列を変数dataStrに設定
$dataStr = @'
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
# 変数dataStrを改行で分割し空行は無視し変数dataArysに設定
$dataArys = $dataStr -split "`r`n" | Where-Object {$_}
# 変数dataArysを4つ取り出し空行の要素を追加し2次元配列の変数inputDataに設定
$tempData = @()
$inputData = @()
foreach ($dataAry in $dataArys) {
    $tempData += @($dataAry)
    if (4 -le $tempData.Count) {
        $tempData += ''
        $inputData += @(,$tempData)
        $tempData = @()
    }
}
# 余りがあれば空行の要素を要素が5になるまで追加し変数inputDataに設定
if (1 -le $tempData.Count) {
    $tempData += '' * (5 - $tempData.Count)
    $inputData += @(,$tempData)
}
# 変数inputDataを配列の要素一つ目で並び変え変数outputDataに設定
$outputData = $inputData | Sort-Object { $_[0] }
# 変数inputDataと変数outputDataが同じ内容であればOKを出力し$outputDataを出力
if ((($inputData -split ',') -join ',') -eq (($outputData -split ',') -join ',')) {
    Write-Host 'OK'
    $outputData
# でなければNGを出力し$outputDataをクリップボードに出力
} else {
    Write-Host 'NG'
    $outputData | Set-Clipboard
}
