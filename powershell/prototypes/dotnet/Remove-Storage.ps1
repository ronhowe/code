<###############################################################################
https://github.com/ronhowe
###############################################################################>

#requires -Module "Az.Storage"
#requires -Module "SqlServer"

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$DbConnectionString = "Server=LOCALHOST;Database=MyDatabase;Integrated Security=True;Application Name=$($MyInvocation.MyCommand.Name);Encrypt=False;Connect Timeout=1;Command Timeout=0;",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$AzConnectionString = "UseDevelopmentStorage=true;",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$LogsPath = "$HOME\repos\ronhowe\code\logs"
)

$ErrorActionPreference = "Stop"
Write-Output "Running $($MyInvocation.MyCommand.Name)"

Write-Debug "`$DbConnectionString = $DbConnectionString"
Write-Debug "`$AzConnectionString = $AzConnectionString"
Write-Debug "`$LogsPath = $LogsPath"

Write-Output "Truncating Database Table"
Invoke-SqlCmd -ConnectionString $DbConnectionString -Query "TRUNCATE TABLE [MyTable];"

Write-Output "Removing Azure Storage Table"
New-AzStorageContext -ConnectionString $AzConnectionString |
Get-AzStorageTable -Name "MyCloudTable" -ErrorAction SilentlyContinue |
Remove-AzStorageTable -Name "MyCloudTable" -Force

Write-Output "Removing Logs"
Get-ChildItem -Path $LogsPath -Recurse |
Remove-Item -Force
