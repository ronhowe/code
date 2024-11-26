[CmdletBinding()]
param(
)
Describe "Testing Get-Version" {
    BeforeAll {
        Write-Verbose "Importing Configuration"
        . "$PSScriptRoot\..\..\..\Import-Configuration.ps1"
    
        Import-Module -Name "$modulePath\$moduleName" -Force

        Mock -ModuleName $moduleName Get-Module { return @{ Version = "x.x.x" } }
    }
    It "Returns Expected" {
        Get-Version |
        Should -Be "x.x.x"
    }
}
