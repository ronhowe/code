#requires -Module "Az.Storage"
#requires -Module "SqlServer"

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Verbose "Truncating Database Table"
Invoke-SqlCmd -ConnectionString "Server=localhost;Database=MyDatabase;Integrated Security=True;Application Name=$($MyInvocation.MyCommand.Name);Encrypt=False;Connect Timeout=1;Command Timeout=0;" -Query "TRUNCATE TABLE [MyTable];"

Write-Verbose "Removing Azure Storage Table"
New-AzStorageContext -ConnectionString "UseDevelopmentStorage=true;" |
Get-AzStorageTable -Name "MyCloudTable" -ErrorAction SilentlyContinue |
Remove-AzStorageTable -Name "MyCloudTable" -Force

Write-Verbose "Removing Logs"
Get-ChildItem -Path "$HOME\repos\ronhowe\code\logs" -Recurse |
Remove-Item -Force
