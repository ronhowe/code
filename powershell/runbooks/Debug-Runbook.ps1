#requires -PSEdition "Core"

[CmdletBinding()]
param(
    [ValidateNotNullOrEmpty()]
    [string]
    $Why = "Debugging"
)

Clear-Host

Write-Verbose "Writing Who"
Write-Output $env:USERNAME

Write-Verbose "Writing What"
Write-Output $PSVersionTable.PSEdition

Write-Verbose "Writing Where"
Write-Output $env:COMPUTERNAME

Write-Verbose "Writing When"
Write-Output (Get-Date -AsUTC).Date

Write-Verbose "Writing Why"
Write-Output $Why

Write-Verbose "Writing How"
Write-Output $MyInvocation.MyCommand.Name
## NOTE: PowerShell Core Only
Write-Output $PSCommandPath
