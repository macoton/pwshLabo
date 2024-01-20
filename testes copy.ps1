Clear-Host
Set-StrictMode -Version 2.0
$utf8bomInfos = @{
    boms = (
        , (, (0xef, 0xbb, 0xbf))
    )
    bins = (
        ((, 0x00), (, 0x7f)),
        ((0xc2, 0x80), (0xdf, 0xbf)),
        ((0xe0, 0x80, 0x80), (0xef, 0xbf, 0xbf)),
        ((0xf4, 0xbf, 0xbf, 0xbf), (0xf0, 0x80, 0x80, 0x80))
    )
}
$utf8Infos = @{
    bins = (
        ((, 0x00), (, 0x7f)),
        ((0xc2, 0x80), (0xdf, 0xbf)),
        ((0xe0, 0x80, 0x80), (0xef, 0xbf, 0xbf)),
        ((0xf4, 0xbf, 0xbf, 0xbf), (0xf0, 0x80, 0x80, 0x80))
    )
}
function SetInfos {
    foreach ($arg in $args) {
        if ($arg.ContainsKey('boms')) {
            $arg.bomMaxCount = ($arg.boms | ForEach-Object { $_ | ForEach-Object { $_.Count } } | Measure-Object -Maximum).Maximum
        }
        if ($arg.ContainsKey('bins')) {
            $arg.binMaxCount = ($arg.bins | ForEach-Object { $_ | ForEach-Object { $_.Count } } | Measure-Object -Maximum).Maximum
        }
    }
}
SetInfos $utf8bomInfos $utf8Infos
