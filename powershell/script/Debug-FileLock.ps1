$filePath = "C:\Program Files\VideoLAN\VLC\libvlc.dll"

$processes = Get-Process
$lockingProcesses = $processes | Where-Object { $_.Modules.FileName -contains $filePath }

if ($lockingProcesses) {
    $lockingProcesses | Select-Object -Property ProcessName, Id, Modules
}
else {
    Write-Host "No processes have a lock on $filePath."
}
