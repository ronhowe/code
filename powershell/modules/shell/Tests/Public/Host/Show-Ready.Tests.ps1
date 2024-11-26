[CmdletBinding()]
param(
)
Describe "Testing Show-Ready" {
    BeforeAll {
        Write-Verbose "Importing Configuration"
        . "$PSScriptRoot\..\..\..\Import-Configuration.ps1"
    
        Import-Module -Name "$modulePath\$moduleName" -Force
    }
    It "Invoke Does Not Throw" {
        { Show-Ready } |
        Should -Not -Throw
    }
    It "Invoke Returns Nothing" {
        Show-Ready |
        Should -BeNullOrEmpty
    }
}
