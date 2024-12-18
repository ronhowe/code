#requires -Module "Az.Storage"
#requires -Module "SqlServer"

$ErrorActionPreference = "Stop"
Write-Output "Running $($MyInvocation.MyCommand.Name)"

Write-Output "Truncating Database Table"
Invoke-SqlCmd -ConnectionString "Server=LOCALHOST;Database=MyDatabase;Integrated Security=True;Application Name=$($MyInvocation.MyCommand.Name);Encrypt=False;Connect Timeout=1;Command Timeout=0;" -Query "TRUNCATE TABLE [MyTable];"

Write-Output "Removing Azure Storage Table"
New-AzStorageContext -ConnectionString "UseDevelopmentStorage=true;" |
Get-AzStorageTable -Name "MyCloudTable" -ErrorAction SilentlyContinue |
Remove-AzStorageTable -Name "MyCloudTable" -Force

Write-Output "Removing Logs"
Get-ChildItem -Path "$HOME\repos\ronhowe\code\logs" -Recurse |
Remove-Item -Force
