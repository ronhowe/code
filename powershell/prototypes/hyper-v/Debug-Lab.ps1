throw

Import-Module -Name "Hyper-V"
Import-Module -Name "Pester"
Import-Module -Name "PSDesiredStateConfiguration"

Set-Location -Path "$HOME\repos\ronhowe\code\powershell\prototypes\hyper-v"

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

## NOTE: Creates public key (.CER) and public/private key pair (.PFX).  Only .CER is Git safe.
. .\New-DscEncryptionCertificate.ps1
New-DscEncryptionCertificate -Verbose

. .\Publish-DscEncryptionCertificate.ps1
Publish-DscEncryptionCertificate -Nodes $nodes -Credential $credential -PfxPath ".\DscPrivateKey.pfx" -PfxPassword $pfxPassword -Verbose

. .\Install-GuestDscResources.ps1
Install-GuestDscResources -Nodes $nodes -Credential $credential -Verbose

## TODO: YOU ARE HERE
# & ".\Invoke-GuestDsc.ps1" -Nodes $nodes -Credential $credential -Verbose
# & ".\Wait-GuestDsc.ps1" -ComputerName $nodes -Credential $credential -RetryInterval 3
# & ".\Test-Lab.ps1" -Verbose
