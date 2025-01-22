Describe "Dependency Tests" {
    BeforeAll {
        $ErrorActionPreference = "Stop"
        $ProgressPreference = "SilentlyContinue"
        $WarningPreference = "SilentlyContinue"
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
