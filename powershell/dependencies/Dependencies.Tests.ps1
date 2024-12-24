#requires -Module "Pester"
[CmdletBinding()]
param ()

$ErrorActionPreference = "Stop"

Describe "Dependency Tests" {
    BeforeAll {
        $ErrorActionPreference = "Stop"
        $ProgressPreference = "SilentlyContinue"
        $WarningPreference = "SilentlyContinue"

        Write-Host "$((Get-Date).ToString()) (LOCAL)" -ForegroundColor Yellow
        Write-Host "$((Get-Date -AsUTC).ToString()) (UTC)" -ForegroundColor Yellow
    }
    It "Asserting Dependency Is Current @{ ModuleName = '<Name>' ; RequiredVersion = '<Version>' }" -ForEach `
    $(
        (Import-PowerShellDataFile -Path "$PSScriptRoot\Dependencies.psd1").Modules
    ) {
        Find-Module -Name $Name -Repository $Repository -Verbose:$false -WarningAction SilentlyContinue |
        Select-Object -ExpandProperty "Version" |
        Should -Be $Version
    }
    It "Asserting Dependency Is Installed @{ ModuleName = '<Name>' ; RequiredVersion = '<Version>' }" -ForEach `
    $(
        (Import-PowerShellDataFile -Path "$PSScriptRoot\Dependencies.psd1").Modules
    ) {
        Get-Module -FullyQualifiedName @{ ModuleName = $Name ; RequiredVersion = $Version } -ListAvailable |
        Should -Not -BeNullOrEmpty
    }
}
