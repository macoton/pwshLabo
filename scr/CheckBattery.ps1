#!/usr/bin/env pwsh
[CmdletBinding()]
param (
    [Parameter(ValueFromRemainingArguments = $true)]$args
)
if ($null -ne $args) {
    throw
}

function Start-Check-Battery {
    param (
        $openSpeech,
        $lowLevel,
        $lowSpeech,
        $hiLevel,
        $hiSpeech,
        [switch]$notStartJob,
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    if ($null -ne $args) {
        throw
    }
    $openSpeech = $openSpeech ?? $settingScr.checkBattery.openSpeech
    $lowLevel = $lowLevel ?? $settingScr.checkBattery.lowLevel
    $lowSpeech = $lowSpeech ?? $settingScr.checkBattery.lowSpeech
    $hiLevel = $hiLevel ?? $settingScr.checkBattery.hiLevel
    $hiSpeech = $hiSpeech ?? $settingScr.checkBattery.hiSpeech
    if ($settingScr.checkBattery.notStartJob) {
        $notStartJob = !$notStartJob
    }
    $sb = {
        param (
            $openSpeech,
            $lowLevel,
            $lowSpeech,
            $hiLevel,
            $hiSpeech
        )
        $ss = [System.Speech.Synthesis.SpeechSynthesizer]::new()
        $ss.Speak(($openSpeech -f $lowLevel, $hiLevel))
        $ss.Dispose()
        for (;;) {
            Start-Sleep 1
            $cim = Get-CimInstance Win32_Battery
            $status = $cim.BatteryStatus
            $level = $cim.EstimatedChargeRemaining
            if ((1 -eq $status -and $lowLevel -gt $level) -or # 充電外かつ下限値未満
            (2 -eq $status -and $hiLevel -le $level)) { # 充電中かつ上限値以上
                $ss = [System.Speech.Synthesis.SpeechSynthesizer]::new()
                if ($lowLevel -gt $level) {
                    $ss.Speak(($lowSpeech -f $lowLevel, $hiLevel, $level))
                } else {
                    $ss.Speak(($hiSpeech -f $lowLevel, $hiLevel, $level))
                }
                $ss.Dispose()
            }
        }
    }
    $al = $openSpeech, $lowLevel, $lowSpeech, $hiLevel, $hiSpeech
    if ($notStartJob) {
        Invoke-Command $sb -ArgumentList $al
        return
    }
    Stop-Check-Battery
    $job = Start-Job $sb -ArgumentList $al
    $settingScr.checkBattery.id = $job.Id
    $settingScr.checkBattery.command = $job.Command
}
Set-Alias scba Start-Check-Battery

function Stop-Check-Battery {
    param (
        [switch]$byCommand,
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    if ($null -ne $args) {
        throw
    }
    if ($byCommand) {
        if ($null -eq $settingScr.checkBattery.command) {
            return
        }
        Get-Job |
        Where-Object {
            'Running' -eq $_.State -and
            $settingScr.checkBattery.command -eq $_.Command } |
        Stop-Job
        $settingScr.checkBattery.id = $null
        $settingScr.checkBattery.command = $null
        return
    }
    if ($null -eq $settingScr.checkBattery.id) {
        return
    }
    Stop-Job $settingScr.checkBattery.id
    $settingScr.checkBattery.id = $null
    $settingScr.checkBattery.command = $null
}
Set-Alias stcba Stop-Check-Battery

function Check-Battery {
    param (
        $checkSpeech,
        $checkPrint,
        [Parameter(ValueFromRemainingArguments = $true)]$args
    )
    if ($null -ne $args) {
        throw
    }
    $checkSpeech = $checkSpeech ?? $settingScr.checkBattery.checkSpeech
    $checkPrint = $checkPrint ?? $settingScr.checkBattery.checkPrint
    $cim = Get-CimInstance Win32_Battery
    $status = $cim.BatteryStatus
    $level = $cim.EstimatedChargeRemaining
    $ss = [System.Speech.Synthesis.SpeechSynthesizer]::new()
    $ss.Speak(($checkSpeech -f $status, $level))
    $ss.Dispose()
    $checkPrint -f $status, $level
}
Set-Alias cb Check-Battery

Write-Host $local:MyInvocation.MyCommand.Path

# 設定値
if ($settingScr.ContainsKey('checkBattery')) {
    # 後始末処理
    Stop-Check-Battery
} else {
    # 開始処理
    $settingScr.checkBattery = @{}
}
$settingScr.checkBattery = @{
    # 状態
    id = $null
    command = $null
    # 設定値
    openSpeech = 'かげんち{0}じょうげんち{1}のじょうけんにてでんりょくちぇっくをかいしします'
    lowLevel = 15
    lowSpeech = 'げんざいち{2}がかげんち{0}にとうたつしましたじゅうでんをかいししてください'
    hiLevel = 95
    hiSpeech = 'げんざいち{2}がじょうげんち{1}にとうたつしましたじゅうでんをしゅうりょうしてください'
    notStartJob = $false
    checkSpeech = 'すてーたす{0}げんざいち{1}'
    checkPrint = 'status: {0}、level: {1}'
    startLocation = 'C:\git\pwshLabo'
}

$location = Get-Location
if ($settingScr.checkBattery.startLocation -eq $location) {
    Start-Check-Battery
}

exit 0
