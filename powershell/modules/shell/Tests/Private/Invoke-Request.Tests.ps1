[CmdletBinding()]
param(
)
Describe "Testing Invoke-Request" {
    BeforeAll {
        Write-Verbose "Importing Configuration"
        . "$PSScriptRoot\..\..\Import-Configuration.ps1"

        Import-Module -Name "$modulePath\$moduleName" -Force

        . "$sourcePath\Private\Invoke-Request.ps1"
    }
    It "Uri Invalid Throws" {
        { Invoke-Request -Uri "https://b276ec7d-1d97-46a1-af03-4a0fbb646b63" } |
        Should -Throw
    }
    It "Switch Present Returns" {
        Invoke-Request -Uri "https://catfact.ninja/fact" -ContentOnly |
        Should -Not -BeNullOrEmpty
    }
    It "Switch Absent Returns" {
        Invoke-Request -Uri "https://catfact.ninja/fact" |
        Should -Not -BeNullOrEmpty
    }
}
