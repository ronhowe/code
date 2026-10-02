throw

Clear-Host
$ProgressPreference = "SilentlyContinue"
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

Clear-Host
Import-Module -Name "Hyper-V"
Import-Module -Name "Pester"

Clear-Host
$credential = Get-Credential -Message "Enter Administrator Credential" -UserName "Administrator"

# all at once
$nodes = @("LAB-APP-00", "LAB-DC-00", "LAB-SQL-00", "LAB-WEB-00")
# or one at a time
$nodes = @("LAB-APP-00")
$nodes = @("LAB-DC-00")
$nodes = @("LAB-SQL-00")
$nodes = @("LAB-WEB-00")
# or mix-n-match
$nodes = @("LAB-APP-00", "LAB-SQL-00", "LAB-WEB-00")

Clear-Host
$nodes | Get-VM

Clear-Host
$nodes | Start-VM -Verbose

Clear-Host
$nodes | Stop-VM -Force -Verbose
$nodes | Checkpoint-VM -SnapshotName "READY" -Verbose

Clear-Host
$nodes | Stop-VM -Force -Verbose
$nodes | Get-VMCheckpoint -Name "READY" | Restore-VMCheckpoint -Confirm:$false -Verbose

Clear-Host
$nodes | Get-VMCheckpoint -Name "READY" | Remove-VMCheckpoint -Confirm:$false -Verbose

Clear-Host
& "$HOME\repos\ronhowe\code\powershell\dsc\lab\host\Invoke-HostDsc.ps1" -Nodes $nodes -Ensure "Absent" -Wait

Clear-Host
& "$HOME\repos\ronhowe\code\powershell\dsc\lab\host\Invoke-HostDsc.ps1" -Nodes $nodes -Ensure "Present" -Wait

Clear-Host
Invoke-Pester -Path "$HOME\repos\ronhowe\code\powershell\dsc\lab\host\HostDsc.Tests.ps1" -Output Detailed

## NOTE: Launching this many vmconnect processes is taxing.
Clear-Host
$nodes | ForEach-Object { Start-Process -FilePath "vmconnect.exe" -ArgumentList @("localhost", $_) ; Start-Sleep -Seconds 3 }
Write-Warning "Complete OOBE ; Login To Desktop" -WarningAction Continue

## NOTE: Rename-Guest is idempotent.
Clear-Host
& "$HOME\repos\ronhowe\code\powershell\dsc\lab\guest\Rename-Guest.ps1" -Nodes $nodes -Credential $credential

## NOTE: Initialize-Guest is idempotent.
Clear-Host
& "$HOME\repos\ronhowe\code\powershell\dsc\lab\guest\Initialize-Guest.ps1" -Nodes $nodes -Credential $credential
Write-Warning "Patch Windows" -WarningAction Continue

Clear-Host
& "$HOME\repos\ronhowe\code\powershell\dsc\lab\Remove-DscEncryptionCertificate.ps1"
Get-ChildItem -Path "Cert:\LocalMachine\My\"
& "$HOME\repos\ronhowe\code\powershell\dsc\lab\New-DscEncryptionCertificate.ps1"
& "$HOME\repos\ronhowe\code\powershell\dsc\lab\Get-DscEncryptionCertificate.ps1"
& "$HOME\repos\ronhowe\code\powershell\dsc\lab\Publish-DscEncryptionCertificate.ps1" -Nodes $nodes -Credential $credential -PfxPath "$HOME\repos\ronhowe\code\powershell\dsc\lab\DscPrivateKey.pfx"

Clear-Host
& "$HOME\repos\ronhowe\code\powershell\dsc\lab\guest\Install-GuestDscResources.ps1" -Nodes $nodes -Credential $credential

Clear-Host
$credential = Get-Credential -Message "Enter Administrator Credential" -UserName "Administrator"
$sqlCredential = Get-Credential -Message "Enter SQL Server Credential" -UserName "LAB\svcSqlServer"
$thumbprint = & "$HOME\repos\ronhowe\code\powershell\dsc\lab\Get-DscEncryptionCertificate.ps1"

# all at once
$nodes = @("LAB-APP-00", "LAB-DC-00", "LAB-SQL-00", "LAB-WEB-00")
# or one at a time
$nodes = @("LAB-APP-00")
$nodes = @("LAB-DC-00")
$nodes = @("LAB-SQL-00")
$nodes = @("LAB-WEB-00")
# or mix-n-match
$nodes = @("LAB-APP-00", "LAB-SQL-00", "LAB-WEB-00")

Clear-Host
# without wait
& "$HOME\repos\ronhowe\code\powershell\dsc\lab\guest\Invoke-GuestDsc.ps1" -Nodes $nodes -Credential $credential -SqlCredential $sqlCredential -Thumbprint $thumbprint

Clear-Host
# with wait
& "$HOME\repos\ronhowe\code\powershell\dsc\lab\guest\Invoke-GuestDsc.ps1" -Nodes $nodes -Credential $credential -SqlCredential $sqlCredential -Thumbprint $thumbprint -Wait

Write-Warning "Wait 10 Minutes For Domain Controller Promotion" -WarningAction Continue

Clear-Host
& "$HOME\repos\ronhowe\code\powershell\dsc\lab\guest\Wait-GuestDsc.ps1" -Nodes $nodes -Credential $credential -RetryInterval 5

Clear-Host
Invoke-Pester -Script "$HOME\repos\ronhowe\code\powershell\dsc\lab\guest\GuestDsc.Tests.ps1" -Output Detailed

## NOTE: Install-PowerShell is idempotent.
## NOTE: It works, but causes this error due to WinRm being reset by the installer.
# OpenError: [LAB-DC-00] Processing data from remote server LAB-DC-00 failed with the following error message:
# The I/O operation has been aborted because of either a thread exit or an application request.
# For more information, see the about_Remote_Troubleshooting Help topic.
Clear-Host
Invoke-Command -ComputerName $nodes -Credential $credential -FilePath "$HOME\repos\ronhowe\code\powershell\script\Install-PowerShell.ps1"

## NOTE: Install-WebDeploy is idempotent.
Clear-Host
Invoke-Command -ComputerName $nodes -Credential $credential -FilePath "$HOME\repos\ronhowe\code\powershell\script\Install-WebDeploy.ps1"

## NOTE: Install-NetCoreHostingBundle is idempotent.
## TODO: Not working.
Invoke-Command -ComputerName $nodes -Credential $credential -FilePath "$HOME\repos\ronhowe\code\powershell\script\Install-NetCoreHostingBundle.ps1"

## TODO: Refactor into GuestDsc.  Enables Web Management Service for publishing web applications.
Clear-Host
Invoke-Command -ComputerName $nodes -Credential $credential -ScriptBlock {
    $port = 8172
    New-NetFirewallRule -DisplayName "Allow TCP Inbound Port $port - Domain" -Direction Inbound -Protocol TCP -LocalPort $port -Action Allow -Profile Domain
    New-NetFirewallRule -DisplayName "Allow TCP Inbound Port $port - Private" -Direction Inbound -Protocol TCP -LocalPort $port -Action Allow -Profile Private
}

Clear-Host
New-CimSession -ComputerName $nodes -Credential $credential -OutVariable "sessions"

Clear-Host
Get-CimSession |
Remove-CimSession -Verbose

Clear-Host
Get-Command -Module "PSDesiredStateConfiguration"

Clear-Host
Test-DscConfiguration -CimSession $sessions

Clear-Host
Test-DscConfiguration -CimSession $sessions -Verbose

Clear-Host
Start-Transcript -Path "$HOME\repos\ronhowe\code\powershell\dsc\lab\Debug-Lab.log" -Force
Test-DscConfiguration -CimSession $sessions -Verbose
Stop-Transcript

Clear-Host
Get-Content -Path "$HOME\repos\ronhowe\code\powershell\dsc\lab\Debug-Lab.log"

Clear-Host
Select-String -Path "$HOME\repos\ronhowe\code\powershell\dsc\lab\Debug-Lab.log" -SimpleMatch "Completed processing test operation." -Context 0,1

Clear-Host
Remove-Item -Path "$HOME\repos\ronhowe\code\powershell\dsc\lab\Debug-Lab.log" -Force -Verbose

Clear-Host
Get-DscConfiguration -CimSession $sessions |
Export-Csv -Path "$HOME\repos\ronhowe\code\powershell\dsc\lab\Debug-Lab.csv" -NoTypeInformation -Force

Clear-Host
Get-Content -Path "$HOME\repos\ronhowe\code\powershell\dsc\lab\Debug-Lab.csv"

Clear-Host
Import-Csv -Path "$HOME\repos\ronhowe\code\powershell\dsc\lab\Debug-Lab.csv" |
Sort-Object -Property @("PSComputerName", "ModuleName", "ResourceId") |
Select-Object -Property @("PSComputerName", "ModuleName", "ModuleVersion", "ResourceId", "Message") |
Format-Table -AutoSize

Clear-Host
Remove-Item -Path "$HOME\repos\ronhowe\code\powershell\dsc\lab\Debug-Lab.csv" -Force -Verbose

Clear-Host
Start-DscConfiguration -CimSession $sessions -UseExisting -Wait -Verbose

Clear-Host
Get-Job

Clear-Host
Get-Job |
Remove-Job

Clear-Host
Start-DscConfiguration -CimSession $sessions -UseExisting -Verbose -OutVariable "jobs"
$jobs |
Wait-Job

Clear-Host
Receive-Job -Job $jobs -Verbose

Clear-Host
& "$HOME\repos\ronhowe\code\powershell\dsc\lab\guest\Invoke-GuestDscLite.ps1" -Nodes $nodes -Credential $credential -Wait

Clear-Host
Restore-DscConfiguration -CimSession $sessions -Verbose

Clear-Host
& "$HOME\repos\ronhowe\code\powershell\dsc\lab\guest\Invoke-GuestDscLite.ps1" -Nodes $nodes -Credential $credential -PublishOnly -Wait
