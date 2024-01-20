Clear-Host
try {
    try {
        # 例外を発生させるコード
        throw "エラーが発生します。"
    } catch {
        # 例外を受け取り、改めて例外を発生させるコード
        Write-Host (
            '{0} {1} {2} 異常終了' -f (
                ($_.InvocationInfo.PositionMessage -replace '\s+', ' '),
                ($_.Exception.Message -replace '\s+', ' '),
                $_.CategoryInfo.ToString()
            )
        )
        if ($_.Exception.InnerException) {
            $a = 1
        }
        throw "エラーが発生しました。"
    }
} catch {
    # 例外を受け取り、改めて例外を発生させるコード
    Write-Host (
        '{0} {1} {2} 異常終了' -f (
            ($_.InvocationInfo.PositionMessage -replace '\s+', ' '),
            ($_.Exception.Message -replace '\s+', ' '),
            $_.CategoryInfo.ToString()
        )
    )
    if ($_.Exception.InnerException) {
        $a = 1
    }
    throw
}
