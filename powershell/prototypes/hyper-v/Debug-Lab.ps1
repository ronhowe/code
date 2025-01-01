throw

Import-Module -Name "Hyper-V"
Import-Module -Name "Pester"
Import-Module -Name "PSDesiredStateConfiguration"

Set-Location -Path "$HOME\repos\ronhowe\code\powershell\prototypes\hyper-v"

Find-Module -Name "ActiveDirectoryCSDsc" -Repository "PSGallery"
Find-Module -Name "ActiveDirectoryDsc" -Repository "PSGallery"
Find-Module -Name "ComputerManagementDsc" -Repository "PSGallery"
Find-Module -Name "NetworkingDsc" -Repository "PSGallery"
Find-Module -Name "SqlServerDsc" -Repository "PSGallery"
Find-Module -Name "xHyper-V" -Repository "PSGallery"

## NOTE: Versions as of 2025-01-01.
# Version    Name                                Repository           Description
# -------    ----                                ----------           -----------
# 5.0.0      ActiveDirectoryCSDsc                PSGallery            DSC resources for installing, uninstalling and configuring Certificate Services components in Windows Server.
# 6.6.0      ActiveDirectoryDsc                  PSGallery            The ActiveDirectoryDsc module contains DSC resources for deployment and configuration of Active Directory....
# 9.2.0      ComputerManagementDsc               PSGallery            DSC resources for configuration of a Windows computer. These DSC resources allow you to perform computer management tasks, such as renaming the computer,...
# 9.0.0      NetworkingDsc                       PSGallery            DSC resources for configuring settings related to networking.
# 17.0.0     SqlServerDsc                        PSGallery            Module with DSC resources for deployment and configuration of Microsoft SQL Server.
# 3.18.0     xHyper-V                            PSGallery            This module contains DSC resources for deployment and configuration of Microsoft Hyper-V.

. .\Install-HostDscResources.ps1
Install-HostDscResources -Verbose

# all at once
$nodes = @("LAB-DC-00", "LAB-APP-00", "LAB-SQL-00", "LAB-WEB-00")
# or one at a time
# $nodes = @("LAB-DC-00")
# $nodes = @("LAB-APP-00")
# $nodes = @("LAB-SQL-00")
# $nodes = @("LAB-WEB-00")

$credential = Get-Credential -Message "Enter Administrator Credential" -UserName "Administrator"
$pfxPassword = Read-Host -Prompt "Enter PFX Password" -AsSecureString

. .\Invoke-HostDsc.ps1

. .\Remove-Lab.ps1
Remove-Lab -Nodes $nodes -Verbose

. .\New-Lab.ps1
New-Lab -Nodes $nodes -Verbose

$nodes | Stop-VM -Force -Verbose
$nodes | Checkpoint-VM -SnapshotName "NEW" -Verbose
$nodes | Start-VM -Verbose

Invoke-Pester -Script ".\HostDsc.Tests.ps1" -Output Detailed

## NOTE: Launching this many vmconnect processes is taxing.
$nodes | ForEach-Object { Start-Process -FilePath "vmconnect.exe" -ArgumentList @("localhost", $_) }

## NOTE: Complete the OOBE process including login for each node.

$nodes | Stop-VM -Force -Verbose
$nodes | Checkpoint-VM -SnapshotName "POST-OOBE" -Verbose
$nodes | Start-VM -Verbose

## NOTE: Rename-Guest is idempotent.
. .\Rename-Guest.ps1
Rename-Guest -Nodes $nodes -Credential $credential -Verbose

$nodes | Stop-VM -Force -Verbose
$nodes | Checkpoint-VM -SnapshotName "POST-RENAME" -Verbose
$nodes | Start-VM -Verbose

## NOTE: Initialize-Guest is idempotent.
. .\Initialize-Guest.ps1
Initialize-Guest -Nodes $nodes -Credential $credential -Verbose

## NOTE: Patch Windows for each node.

$nodes | Stop-VM -Force -Verbose
$nodes | Checkpoint-VM -SnapshotName "POST-INITIALIZE" -Verbose
$nodes | Start-VM -Verbose

. .\Install-GuestDscResources.ps1
Install-GuestDscResources -Nodes $nodes -Credential $credential -Verbose

## NOTE: Creates public key (.CER) and public/private key pair (.PFX).  Only .CER is Git safe.
# first time
. .\New-DscEncryptionCertificate.ps1
$thumbprint = (New-DscEncryptionCertificate -Verbose).Thumbprint
# and beyond
$thumbprint = Get-ChildItem -Path "Cert:\LocalMachine\My\" |
Where-Object { $_.Subject -eq "CN=DscEncryptionCert" } |
Select-Object -ExpandProperty "Thumbprint"

. .\Publish-DscEncryptionCertificate.ps1
Publish-DscEncryptionCertificate -Nodes $nodes -Credential $credential -PfxPath ".\DscPrivateKey.pfx" -PfxPassword $pfxPassword -Verbose

. .\Invoke-GuestDsc.ps1
Invoke-GuestDsc -Nodes $nodes -Credential $credential -DscEncryptionCertificateThumbprint $thumbprint -Verbose

. .\Wait-GuestDsc.ps1
Wait-GuestDsc -Nodes $nodes -Credential $credential -RetryInterval 3 -Verbose

Invoke-Pester -Script ".\GuestDsc.Tests.ps1" -Output Detailed
