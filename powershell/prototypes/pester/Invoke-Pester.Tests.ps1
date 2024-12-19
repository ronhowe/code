#requires -Module "Pester"

Invoke-Pester -Path "$PSScriptRoot\Pester.Tests.ps1" -Output Detailed
