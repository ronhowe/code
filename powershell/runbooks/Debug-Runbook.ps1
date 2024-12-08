<###############################################################################
https://github.com/ronhowe
###############################################################################>

#requires -PSEdition "Core"

param(
    [string]
    $Why = "Power-On Self-Test"
)

Write-Output "WHO"
Write-Output $env:USERNAME

Write-Output "WHAT"
Write-Output $PSVersionTable.PSEdition

Write-Output "WHERE"
Write-Output $env:COMPUTERNAME

Write-Output "WHEN"
Write-Output (Get-Date -AsUTC).Date

Write-Output "WHY"
Write-Output $Why

Write-Output "HOW"
Write-Output $PSCommandPath # $($MyInvocation.MyCommand.Name)
