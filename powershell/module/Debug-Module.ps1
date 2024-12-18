#requires -PSEdition "Core"
#requires -Module "Pester"

[CmdletBinding()]
param (
)

$ErrorActionPreference = "Stop"
Write-Output "Running $($MyInvocation.MyCommand.Name)"

Write-Output "Importing Configuration"
. "$PSScriptRoot\Import-Configuration.ps1"

Get-Module -Name $moduleName |
Remove-Module -Force -Verbose

Write-Output "Starting Build"
& "$PSScriptRoot\Start-Build.ps1"

## TODO: Getting an assembly already loaded error on some machines. -ErrorAction SilentlyContinue as workaround.
Import-Module -Name "$modulePath\$moduleName" -Force -ErrorAction SilentlyContinue
