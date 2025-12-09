throw

$ProgressPreference = "SilentlyContinue"

Import-Module -Name "Hyper-V"
Import-Module -Name "Pester"

# all at once
$nodes = @("LAB-APP-00", "LAB-DC-00", "LAB-SQL-00", "LAB-WEB-00")
# or one at a time
$nodes = @("LAB-APP-00")
$nodes = @("LAB-DC-00")
$nodes = @("LAB-SQL-00")
$nodes = @("LAB-WEB-00")
# or mix-n-match
$nodes = @("LAB-APP-00", "LAB-SQL-00", "LAB-WEB-00")

& "$HOME\repos\ronhowe\powershell\dsc\lab\host\Invoke-HostDsc.ps1" -Nodes $nodes -Ensure "Absent" -Wait

& "$HOME\repos\ronhowe\powershell\dsc\lab\host\Invoke-HostDsc.ps1" -Nodes $nodes -Ensure "Present" -Wait

$nodes | Stop-VM -Force -Verbose
$nodes | Checkpoint-VM -SnapshotName "NEW" -Verbose

$nodes | Start-VM -Verbose
$nodes | Get-VM

Invoke-Pester -Script "$HOME\repos\ronhowe\powershell\dsc\lab\host\HostDsc.Tests.ps1" -Output Detailed

## NOTE: Launching this many vmconnect processes is taxing.
$nodes | ForEach-Object { Start-Process -FilePath "vmconnect.exe" -ArgumentList @("localhost", $_) ; Start-Sleep -Seconds 3 }
Write-Warning "Complete OOBE ; Login To Desktop" -WarningAction Continue

$nodes | Stop-VM -Force -Verbose
$nodes | Checkpoint-VM -SnapshotName "POST-OOBE" -Verbose

$nodes | Start-VM -Verbose
$nodes | Get-VM

$credential = Get-Credential -Message "Enter Administrator Credential" -UserName "Administrator"

## NOTE: Rename-Guest is idempotent.
& "$HOME\repos\ronhowe\powershell\dsc\lab\guest\Rename-Guest.ps1" -Nodes $nodes -Credential $credential

$nodes | Stop-VM -Force -Verbose
$nodes | Checkpoint-VM -SnapshotName "POST-RENAME" -Verbose

$nodes | Start-VM -Verbose
$nodes | Get-VM

## NOTE: Initialize-Guest is idempotent.
& "$HOME\repos\ronhowe\powershell\dsc\lab\guest\Initialize-Guest.ps1" -Nodes $nodes -Credential $credential
Write-Warning "Patch Windows" -WarningAction Continue

$nodes | Stop-VM -Force -Verbose
$nodes | Checkpoint-VM -SnapshotName "POST-INITIALIZE" -Verbose

$nodes | Start-VM -Verbose
$nodes | Get-VM

& "$HOME\repos\ronhowe\powershell\dsc\lab\Remove-DscEncryptionCertificate.ps1"
Get-ChildItem -Path "Cert:\LocalMachine\My\"
& "$HOME\repos\ronhowe\powershell\dsc\lab\New-DscEncryptionCertificate.ps1"
& "$HOME\repos\ronhowe\powershell\dsc\lab\Get-DscEncryptionCertificate.ps1"
& "$HOME\repos\ronhowe\powershell\dsc\lab\Publish-DscEncryptionCertificate.ps1" -Nodes $nodes -Credential $credential -PfxPath "$HOME\repos\ronhowe\powershell\dsc\lab\DscPrivateKey.pfx"

& "$HOME\repos\ronhowe\powershell\dsc\lab\guest\Install-GuestDscResources.ps1" -Nodes $nodes -Credential $credential

$nodes | Stop-VM -Force -Verbose
$nodes | Checkpoint-VM -SnapshotName "POST-DSC-PRE-REQUISITES" -Verbose

$nodes | Start-VM -Verbose
$nodes | Get-VM

$sqlCredential = Get-Credential -Message "Enter SQL Server Credential" -UserName "LAB\svcSqlServer"
$thumbprint = & "$HOME\repos\ronhowe\powershell\dsc\lab\Get-DscEncryptionCertificate.ps1"

# without wait
& "$HOME\repos\ronhowe\powershell\dsc\lab\guest\Invoke-GuestDsc.ps1" -Nodes $nodes -Credential $credential -SqlCredential $sqlCredential -Thumbprint $thumbprint

# with wait
& "$HOME\repos\ronhowe\powershell\dsc\lab\guest\Invoke-GuestDsc.ps1" -Nodes $nodes -Credential $credential -SqlCredential $sqlCredential -Thumbprint $thumbprint -Wait

Write-Warning "Wait 10 Minutes For Domain Controller Promotion" -WarningAction Continue

& "$HOME\repos\ronhowe\powershell\dsc\lab\guest\Wait-GuestDsc.ps1" -Nodes $nodes -Credential $credential -RetryInterval 5

Invoke-Pester -Script "$HOME\repos\ronhowe\powershell\dsc\lab\guest\GuestDsc.Tests.ps1" -Output Detailed

$nodes | Stop-VM -Force -Verbose
$nodes | Checkpoint-VM -SnapshotName "POST-DSC" -Verbose

$nodes | Start-VM -Verbose
$nodes | Get-VM

## NOTE: Install-PowerShell is idempotent.
## NOTE: It works, but causes this error due to WinRm being reset by the installer.
# OpenError: [LAB-DC-00] Processing data from remote server LAB-DC-00 failed with the following error message:
# The I/O operation has been aborted because of either a thread exit or an application request.
# For more information, see the about_Remote_Troubleshooting Help topic.
Invoke-Command -ComputerName $nodes -Credential $credential -FilePath "$HOME\repos\ronhowe\powershell\script\Install-PowerShell.ps1"

## NOTE: Install-WebDeploy is idempotent.
Invoke-Command -ComputerName $nodes -Credential $credential -FilePath "$HOME\repos\ronhowe\powershell\script\Install-WebDeploy.ps1"

## NOTE: Install-NetCoreHostingBundle is idempotent.
## TODO: Not working.
Invoke-Command -ComputerName $nodes -Credential $credential -FilePath "$HOME\repos\ronhowe\powershell\script\Install-NetCoreHostingBundle.ps1"

## TODO: Refactor into GuestDsc.  Enables Web Management Service for publishing web applications.
Invoke-Command -ComputerName $nodes -Credential $credential -ScriptBlock {
    $port = 8172
    New-NetFirewallRule -DisplayName "Allow TCP Inbound Port $port - Domain" -Direction Inbound -Protocol TCP -LocalPort $port -Action Allow -Profile Domain
    New-NetFirewallRule -DisplayName "Allow TCP Inbound Port $port - Private" -Direction Inbound -Protocol TCP -LocalPort $port -Action Allow -Profile Private
}

$nodes | Stop-VM -Force -Verbose
$nodes | Checkpoint-VM -SnapshotName "READY" -Verbose

$nodes | Start-VM -Verbose
$nodes | Get-VM
