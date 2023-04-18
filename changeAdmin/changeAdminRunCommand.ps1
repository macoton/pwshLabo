# 管理者権限を付与してコマンドを実行
function ChangeAdminRunCommand() {
    param (
        # コマンド
        $cmd
    )
    # 管理者権限が無い場合
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
        # 管理者権限を付与して実行し終了するまで待機
        $pwsh = (Get-Process -Id $pid).ProcessName
        $cmd = $cmd -replace '"', '\"';
        # PowershellCoreでSet-Locationは不要
        Start-Process $pwsh ('-Command "Set-Location {0}; {1}"' -f $pwd.Path, $cmd) -Verb RunAs -Wait
    }
    # 管理者権限が有る場合
    else {
        # 普通に実行
        Invoke-Expression $cmd
    }
}
