#requires -Module "Pester"
[CmdletBinding()]
param ()

$ErrorActionPreference = "Stop"

Describe "Dependency Tests" {
    BeforeAll {
        $ErrorActionPreference = "Stop"
        $ProgressPreference = "SilentlyContinue"
        $WarningPreference = "SilentlyContinue"

        Write-Host "$([DateTime]::Now.ToString(`"yyyy-MM-dd HH:mm:ss.fff`")) (LOCAL)"
        Write-Host "$([DateTime]::UtcNow.ToString(`"yyyy-MM-dd HH:mm:ss.fff`")) (UTC)"
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
        Get-Module -FullyQualifiedName @{ ModuleName = $Name ; RequiredVersion = $Version } -ListAvailable -Verbose:$false |
        Should -Not -BeNullOrEmpty
    }
}
