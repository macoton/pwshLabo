{
$ParentProcessIds = Get-CimInstance -Class Win32_Process -Filter "Name = 'pwsh.exe'"
$ParentProcessIds[0].ParentProcessId

$ParentProcessIds = Get-CimInstance Win32_Process -Filter "processId = $PID"

Get-CimInstance Win32_Process -Filter "Id = $PID"

(Get-Item '.').Count
(Get-Item '*').Count

(Get-Item '.').GetType().Name
(Get-Item '*').GetType().Name

(Get-Item '.').GetType().BaseType.Name
(Get-Item '*').GetType().BaseType.Name

Get-ChildItem

$p = Get-Process firefox
$parent = (gwmi win32_process | ? processid -eq  $p.Id).parentprocessid
$parent
}

function global:GetProcessId {
    param (
        [Int32]$processId = $PID,
        [switch]$under,
        [switch]$list
    )
    if (-not($under)) {
        while ($true) {
            $process2 = Get-CimInstance Win32_Process -Filter "processId = $processId"
            if (-not($process2)) {
                break
            }
            $process = Get-Process -Id $process2.ParentProcessId -ErrorAction SilentlyContinue
            if (-not($process)) {
                break
            }
            if ($List) {
                Write-Host ('{0} {1} {2}' -f $processId, $process2.ParentProcessId, $process.Name)
            }
            $processId = $process2.ParentProcessId
        }
        if ($List) {
            Write-Host ('{0} {1} {2}' -f $processId, 1, $process.Name)
        }
        return $processId
    } else {
        $restProcessIds = $processId
        $retProcessIds = $null
        while ($true) {
            if (-not($restProcessIds)) {
                break
            }
            $processId = $restProcessIds[0]
            $process = Get-Process -Id $processId -ErrorAction SilentlyContinue
            if (-not($process)) {
                break
            }
            $process2 = Get-CimInstance Win32_Process -Filter "processId = $processId"
            if (-not($process2)) {
                break
            }
            if ($List) {
                #Write-Host ('{0} {1} {2} {3}' -f $processId, $process2.ParentProcessId, $process.Name, $process2.CommandLine)
                Write-Host ('{0} {1} {2}' -f $processId, $process2.ParentProcessId, $process.Name)
            }
            $processes2 = Get-CimInstance Win32_Process -Filter "parentProcessId = $processId"
            $restProcessIds = $restProcessIds[1..$restProcessIds.Count] + ($processes2 | ForEach-Object { $_.processId })
            $retProcessIds += , $processId
        }
        return $restProcessIds
    }
}

function global:myPs {
    $processId = GetProcessId -list
    $processIds = GetProcessId $processId -under -list
    #Get-Process -Id $processId | Select-Object -ExpandProperty Id | ForEach-Object { Get-Process -Id $_ }
}

myPs
