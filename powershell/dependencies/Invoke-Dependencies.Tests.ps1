#requires -Module "Pester"

[CmdletBinding()]
param (
)

$ErrorActionPreference = "Stop"
Write-Output "Running $($MyInvocation.MyCommand.Name)"

Invoke-Pester -Path "$PSScriptRoot\Dependencies.Tests.ps1" -Output Detailed
