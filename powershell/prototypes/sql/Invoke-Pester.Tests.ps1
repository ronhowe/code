<###############################################################################
https://github.com/ronhowe
###############################################################################>

#requires -Module "Pester"

[CmdletBinding()]
param (
)

$ErrorActionPreference = "Stop"
Write-Debug "Running $($MyInvocation.MyCommand.Name)"

Get-ChildItem -Path $PSScriptRoot -Include "*.Tests.ps1" -Exclude "Invoke-Pester.Tests.ps1"  -Recurse |
ForEach-Object {
    Write-Output $_.FullName
    Invoke-Pester -Path $_.FullName -Output Detailed
}
