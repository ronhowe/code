[CmdletBinding()]
param(
)
Describe "Testing Show-Date" {
    BeforeAll {
        Write-Verbose "Importing Configuration"
        . "$PSScriptRoot\..\..\..\Import-Configuration.ps1"
    
        Import-Module -Name "$modulePath\$moduleName" -Force
    }
    It "Invoke Does Not Throw" {
        { Show-Date } |
        Should -Not -Throw
    }
    It "Invoke Returns Nothing" {
        Show-Date |
        Should -BeNullOrEmpty
    }
}
