[CmdletBinding()]
param(
)
Describe "Testing Get-CatFact" {
    BeforeAll {
        Write-Verbose "Importing Configuration"
        . "$PSScriptRoot\..\..\..\Import-Configuration.ps1"
    
        Import-Module -Name "$modulePath\$moduleName" -Force

        Mock -ModuleName $moduleName Invoke-Request { return "[{'fact':'mock','length':4}]" }
    }
    It "Returns CatFact" {
        Get-CatFact |
        Should -Be "mock"
    }
}
