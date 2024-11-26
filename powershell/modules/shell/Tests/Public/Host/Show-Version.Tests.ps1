[CmdletBinding()]
param(
)
Describe "Testing Show-Version" {
    BeforeAll {
        Write-Verbose "Importing Configuration"
        . "$PSScriptRoot\..\..\..\Import-Configuration.ps1"
    
        Import-Module -Name "$modulePath\$moduleName" -Force
    }
    It "Invoke Does Not Throw" {
        { Show-Version } |
        Should -Not -Throw
    }
    It "Invoke Returns Nothing" {
        Show-Version |
        Should -BeNullOrEmpty
    }
    It "Invoke Mock" {
        Should -InvokeVerifiable
    }
}
