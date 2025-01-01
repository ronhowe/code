throw

Import-Module -Name "Hyper-V"
## LINK: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.diagnostics/?view=powershell-5.1
Import-Module -Name "Microsoft.PowerShell.Diagnostics"
Import-Module -Name "Pester"
Import-Module -Name "PSDesiredStateConfiguration"

Set-Location -Path "$HOME\repos\ronhowe\code\powershell\prototypes\dsc"

. .\Invoke-DevBoxDsc.ps1
Invoke-DevBoxDsc -Verbose

Invoke-Pester -Script ".\DevBoxDsc.Tests.ps1" -Output Detailed

## LINK: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.diagnostics/get-winevent?view=powershell-5.1
Get-WinEvent -ListProvider * -ErrorAction SilentlyContinue |
Select-Object -Property @("Name") |
Sort-Object -Property @("Name")

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
