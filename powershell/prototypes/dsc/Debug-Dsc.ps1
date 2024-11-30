Clear-Host
Test-Path "$HOME\repos\ronhowe\powershell\dsc"

Clear-Host
Set-Location -Path "$HOME\repos\ronhowe\powershell\dsc"

Clear-Host
Import-Module -Name "Pester"

Clear-Host
.\Invoke-DevBoxConfiguration.ps1

Clear-Host
.\Invoke-DevBoxConfiguration.Tests.ps1

# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.diagnostics/?view=powershell-5.1
Clear-Host
Import-Module -Name "Microsoft.PowerShell.Diagnostics"

# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.diagnostics/get-winevent?view=powershell-5.1
Clear-Host
Get-WinEvent -ListProvider * -ErrorAction SilentlyContinue |
Select-Object -Property @("Name") |
Sort-Object -Property @("Name")

Clear-Host
$events = Get-WinEvent -LogName "Microsoft-Windows-Dsc/Operational" -MaxEvents 2
$events |
Select-Object -Property @("TimeCreated", "Message")

$jobId = Read-Host -Prompt "Enter Job ID"
Get-Content -Path "C:\Windows\system32\configuration\ConfigurationStatus\{$jobId}-0.details.json." -Raw

Get-DscLocalConfigurationManager -Verbose
Get-DscConfigurationStatus -Verbose
Get-DscConfiguration -Verbose
Test-DscConfiguration -Verbose
Start-DscConfiguration -UseExisting -Wait -Verbose
