#requires -Module "Pester"

Invoke-Pester -Path "$PSScriptRoot\Dependencies.Tests.ps1" -Output Detailed
