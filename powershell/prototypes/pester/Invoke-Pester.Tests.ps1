#requires -Module "Pester"

[CmdletBinding()]
param (
)

$ErrorActionPreference = "Stop"
Write-Debug "Running $($MyInvocation.MyCommand.Name)"

Invoke-Pester -Path "$PSScriptRoot\Pester.Tests.ps1" -Output Detailed
