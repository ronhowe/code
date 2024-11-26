[CmdletBinding()]
param(
)
Describe "Testing Show-Logo" {
    BeforeAll {
        Write-Verbose "Importing Configuration"
        . "$PSScriptRoot\..\..\..\Import-Configuration.ps1"
    
        Import-Module -Name "$modulePath\$moduleName" -Force
    }
    It "Invoke Does Not Throw" {
        { Show-Logo } |
        Should -Not -Throw
    }
    It "Invoke Returns Nothing" {
        Show-Logo |
        Should -BeNullOrEmpty
    }
}
