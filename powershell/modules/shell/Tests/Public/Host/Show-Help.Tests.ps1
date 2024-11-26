[CmdletBinding()]
param(
)
Describe "Testing Show-Heal" {
    BeforeAll {
        Write-Verbose "Importing Configuration"
        . "$PSScriptRoot\..\..\..\Import-Configuration.ps1"
    
        Import-Module -Name "$modulePath\$moduleName" -Force
    }
    It "Invoke Does Not Throw" {
        { Show-Help } |
        Should -Not -Throw
    }
    It "Invoke Returns Nothing" {
        Show-Ready |
        Should -BeNullOrEmpty
    }
}
