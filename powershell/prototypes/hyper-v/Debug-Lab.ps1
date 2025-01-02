throw

Get-Module -Name "Shell"
Assert-RunAsAdministrator
Assert-RunAsWindowsPowerShell
Set-LocationCode

Import-Module -Name "Hyper-V"
Import-Module -Name "Pester"
Import-Module -Name "PSDesiredStateConfiguration"

# all at once
$nodes = @("LAB-DC-00", "LAB-APP-00", "LAB-SQL-00", "LAB-WEB-00")
# or one at a time
$nodes = @("LAB-DC-00")
$nodes = @("LAB-APP-00")
$nodes = @("LAB-SQL-00")
$nodes = @("LAB-WEB-00")

$credential = Get-Credential -Message "Enter Administrator Credential" -UserName "Administrator"
$pfxPassword = Read-Host -Prompt "Enter PFX Password" -AsSecureString

## NOTE: Creates public key (.CER) and public/private key pair (.PFX).  Only .CER is Git safe.
# first time
. .\powershell\prototypes\hyper-v\New-DscEncryptionCertificate.ps1
$thumbprint = (New-DscEncryptionCertificate -Verbose).Thumbprint ; $thumbprint
# and beyond
$thumbprint = Get-ChildItem -Path "Cert:\LocalMachine\My\" |
Where-Object { $_.Subject -eq "CN=DscEncryptionCert" } |
Select-Object -ExpandProperty "Thumbprint" ; $thumbprint

Find-Module -Name "ActiveDirectoryCSDsc" -Repository "PSGallery"
Find-Module -Name "ActiveDirectoryDsc" -Repository "PSGallery"
Find-Module -Name "ComputerManagementDsc" -Repository "PSGallery"
Find-Module -Name "NetworkingDsc" -Repository "PSGallery"
Find-Module -Name "SqlServerDsc" -Repository "PSGallery"
Find-Module -Name "xHyper-V" -Repository "PSGallery"

## NOTE: xHyper-V 3.18.0 => HyperVDsc 4.x (some day).
# Find-Module -Name "HyperVDsc" -Repository "PSGallery"

## NOTE: Last checked as of 2025-01-02.
# Version    Name                                Repository           Description
# -------    ----                                ----------           -----------
# 5.0.0      ActiveDirectoryCSDsc                PSGallery            DSC resources for installing, uninstalling and configuring Certificate Services components in Windows Server.
# 6.6.0      ActiveDirectoryDsc                  PSGallery            The ActiveDirectoryDsc module contains DSC resources for deployment and configuration of Active Directory....
# 9.2.0      ComputerManagementDsc               PSGallery            DSC resources for configuration of a Windows computer. These DSC resources allow you to perform computer management tasks, such as renaming the computer,...
# 9.0.0      NetworkingDsc                       PSGallery            DSC resources for configuring settings related to networking.
# 17.0.0     SqlServerDsc                        PSGallery            Module with DSC resources for deployment and configuration of Microsoft SQL Server.
# 3.18.0     xHyper-V                            PSGallery            This module contains DSC resources for deployment and configuration of Microsoft Hyper-V.

. .\powershell\prototypes\hyper-v\Install-HostDscResources.ps1
Install-HostDscResources -Verbose

. .\powershell\prototypes\hyper-v\Invoke-HostDsc.ps1

. .\powershell\prototypes\hyper-v\Remove-Lab.ps1
Remove-Lab -Nodes $nodes -Verbose

. .\powershell\prototypes\hyper-v\New-Lab.ps1
New-Lab -Nodes $nodes -Verbose

$nodes | Stop-VM -Force -Verbose
$nodes | Checkpoint-VM -SnapshotName "NEW" -Verbose
$nodes | Start-VM -Verbose

Invoke-Pester -Script ".\powershell\prototypes\hyper-v\HostDsc.Tests.ps1" -Output Detailed

## NOTE: Launching this many vmconnect processes is taxing.
$nodes | ForEach-Object { Start-Process -FilePath "vmconnect.exe" -ArgumentList @("localhost", $_) }

## NOTE: Complete the OOBE process including login for each node.

$nodes | Stop-VM -Force -Verbose
$nodes | Checkpoint-VM -SnapshotName "POST-OOBE" -Verbose
$nodes | Start-VM -Verbose

## NOTE: Rename-Guest is idempotent.
. .\powershell\prototypes\hyper-v\Rename-Guest.ps1
Rename-Guest -Nodes $nodes -Credential $credential -Verbose

$nodes | Stop-VM -Force -Verbose
$nodes | Checkpoint-VM -SnapshotName "POST-RENAME" -Verbose
$nodes | Start-VM -Verbose

## NOTE: Initialize-Guest is idempotent.
. .\powershell\prototypes\hyper-v\Initialize-Guest.ps1
Initialize-Guest -Nodes $nodes -Credential $credential -Verbose

## NOTE: Patch Windows for each node.

$nodes | Stop-VM -Force -Verbose
$nodes | Checkpoint-VM -SnapshotName "POST-INITIALIZE" -Verbose
$nodes | Start-VM -Verbose

. .\powershell\prototypes\hyper-v\Install-GuestDscResources.ps1
Install-GuestDscResources -Nodes $nodes -Credential $credential -Verbose

. .\powershell\prototypes\hyper-v\Publish-DscEncryptionCertificate.ps1
Publish-DscEncryptionCertificate -Nodes $nodes -Credential $credential -PfxPath ".\DscPrivateKey.pfx" -PfxPassword $pfxPassword -Verbose

. .\powershell\prototypes\hyper-v\Invoke-GuestDsc.ps1
Invoke-GuestDsc -Nodes $nodes -Credential $credential -DscEncryptionCertificateThumbprint $thumbprint -Verbose

. .\powershell\prototypes\hyper-v\Wait-GuestDsc.ps1
Wait-GuestDsc -Nodes $nodes -Credential $credential -RetryInterval 3 -Verbose

Invoke-Pester -Script ".\powershell\prototypes\hyper-v\GuestDsc.Tests.ps1" -Output Detailed

## NOTE: Install-PowerShell is idempotent.
Invoke-Command -ComputerName $nodes -Credential $credential -FilePath ".\powershell\runbooks\Install-PowerShell.ps1"
## NOTE: It works, but causes this error due to WinRm being reset by the installer.
# OpenError: [LAB-DC-00] Processing data from remote server LAB-DC-00 failed with the following error message:
# The I/O operation has been aborted because of either a thread exit or an application request.
# For more information, see the about_Remote_Troubleshooting Help topic.

## NOTE: Install-WebDeploy is idempotent.
Invoke-Command -ComputerName $nodes -Credential $credential -FilePath ".\powershell\runbooks\Install-WebDeploy.ps1"

## NOTE: Install-NetCoreHostingBundle is idempotent.
Invoke-Command -ComputerName $nodes -Credential $credential -FilePath ".\powershell\runbooks\Install-NetCoreHostingBundle.ps1"

## TODO: Refactor into GuestDsc.  Enables Web Management Service for publishing web applications.
$port = 8172
New-NetFirewallRule -DisplayName "Allow TCP Inbound Port $port - Domain" -Direction Inbound -Protocol TCP -LocalPort $port -Action Allow -Profile Domain
New-NetFirewallRule -DisplayName "Allow TCP Inbound Port $port - Private" -Direction Inbound -Protocol TCP -LocalPort $port -Action Allow -Profile Private


Copy-Item -Path ".\repos\ronhowe\code\powershell\module\bin\Shell" -Recurse -Destination "C:\installers" -ToSession $session -Verbose -Force

Install-Module -Name "Pester" -Repository "PSGallery" -Force -SkipPublisherCheck
Remove-Module -Name "Pester" -Force -Verbose
Import-Module -Name "Pester" -Force -Verbose
