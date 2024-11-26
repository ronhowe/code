#requires -PSEdition "Core"
#requires -Module "Pester"

[CmdletBinding()]
param (
)

$ErrorActionPreference = "Stop"
Write-Output "Running $($MyInvocation.MyCommand.Name)"

Write-Output "Importing Configuration"
. "$PSScriptRoot\Import-Configuration.ps1"

Invoke-Pester -Path $testsPath -Output Detailed
