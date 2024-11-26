[CmdletBinding()]
param(
)
Describe "Testing Get-Weather" {
    BeforeAll {
        Write-Verbose "Importing Configuration"
        . "$PSScriptRoot\..\..\..\Import-Configuration.ps1"
    
        Import-Module -Name "$modulePath\$moduleName" -Force
    }
    It "Returns Weather" {
        InModuleScope $moduleName {
            Mock Invoke-Request { return "mock" }
            Get-Weather |
            Should -Be "mock"
        }
    }
}
