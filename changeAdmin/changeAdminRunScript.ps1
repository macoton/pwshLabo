# 管理者権限を付与してスクリプトを実行
function ChangeAdminRunScript() {
    param (
        # スクリプト
        $scr
    )
    # 管理者権限が無い場合
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
        # 管理者権限を付与して実行し終了するまで待機
        if ($null -eq $scr) {
            $scr = $Script:MyInvocation.MyCommand.Path
        }
        $pwsh = (Get-Process -Id $pid).ProcessName
        $scr = $scr -replace '"', '\"';
        # PowershellCoreでSet-Locationは不要
        Start-Process $pwsh ('-Command "Set-Location {0}; . {1}"' -f $pwd.Path, $scr) -Verb RunAs -Wait
        exit
    }
    # 管理者権限が有る場合
    else {
        # ここでは何もしない
    }
}
