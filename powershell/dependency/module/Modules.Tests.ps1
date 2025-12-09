BeforeDiscovery {
    $modules = (Import-PowerShellDataFile -Path "$PSScriptRoot\Modules.psd1").Modules |
    Where-Object {
        $_.CompatiblePSEditions -contains $PSEdition
    }
    $modules |
    Out-Null
}
Describe "Modules Tests" {
    Context "Module Currency Tests" {
        It "Asserting Module Is Current @{ ModuleName = '<Name>' ; RequiredVersion = '<Version>' }" -ForEach $modules {
            Find-Module -Name $Name -Repository $Repository -WarningAction SilentlyContinue |
            Select-Object -ExpandProperty "Version" |
            Should -Be $Version
        }
    }
    Context "Module Installation Tests" {
        It "Asserting Module Is Installed @{ ModuleName = '<Name>' ; RequiredVersion = '<Version>' }" -ForEach $modules {
            Get-Module -FullyQualifiedName @{ ModuleName = $Name ; RequiredVersion = $Version } -ListAvailable |
            Should -Not -BeNullOrEmpty
        }
    }
}
