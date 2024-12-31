#requires -RunAsAdministrator

throw

Push-Location -Path "$HOME\repos\ronhowe\code\powershell\prototypes\hyper-v\"

& ".\Install-HostDscResources.ps1" -Verbose

$nodes = @("LAB-DC-00", "LAB-APP-00", "LAB-SQL-00", "LAB-WEB-00")
$credential = Get-Credential -Message "Enter Administrator Credential" -UserName "Administrator"

& ".\Remove-Lab.ps1" -Nodes $nodes -Verbose

& ".\New-Lab.ps1" -Nodes $nodes -Verbose

$nodes | Start-VM -Verbose

## TODO: Refactor to pass in $nodes.
Invoke-Pester -Script ".\HostConfiguration.Tests.ps1" -Output Detailed

## NOTE: Launching this many vmconnect processes is taxing.
$nodes | ForEach-Object { Start-Process -FilePath "vmconnect.exe" -ArgumentList @("localhost", $_) }

## NOTE: Complete the OOBE process for each VM.

## NOTE: Renaming is idempotent.
& ".\Rename-Guest.ps1" -Nodes $nodes -Credential $credential -Verbose

$nodes | Stop-VM -Verbose
$nodes | Checkpoint-VM -SnapshotName "POST-OOBE-POST-RENAME" -Verbose
$nodes | Start-VM -Verbose

& ".\Initialize-Guest.ps1" -Credential $credential

& ".\Install-GuestDependencies.ps1" -Credential $credential -PfxPath ".\DscPrivateKey.pfx" -PfxPassword $credential.Password -Verbose

& ".\Invoke-GuestConfiguration.ps1" -Credential $credential -Verbose

& ".\Wait-GuestConfiguration.ps1" -ComputerName $nodes -Credential $credential -RetryInterval 3

& ".\Test-Lab.ps1" -Verbose
