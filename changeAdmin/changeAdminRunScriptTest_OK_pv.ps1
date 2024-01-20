. .\changeAdmin\changeAdminRunScript.ps1
ChangeAdminRunScript
# コンピュータ名テーブル
$oldNameNewNames = @(
    ('MONITOR-DISPLAY', 'DESKTOP-H8RHRNC'),
    ('DESKTOP-H8RHRNC', 'MONITOR-DISPLAY')
)
$oldName = hostname
foreach ($oldNameNewName in $oldNameNewNames) {
    # コンピュータ名がコンピュータ名の一つ目に有る場合
    if ($oldName -eq $oldNameNewName[0]) {
        # コンピュータ名の二つ目にコンピュータ名を変更
        Rename-Computer -NewName $($oldNameNewName[1]) -Force -Restart
    }
}
