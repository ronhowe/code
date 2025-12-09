BeforeDiscovery {
    $resources = (Import-PowerShellDataFile -Path "$PSScriptRoot\Resources.psd1").Resources
    $resources |
    Out-Null
}
Describe "Resource Tests" {
    Context "Resource Currency Tests" {
        It "Asserting Resource Is Current @{ ModuleName = '<Name>' ; RequiredVersion = '<Version>' }" -ForEach $resources {
            Find-Module -Name $Name -Repository $Repository -WarningAction SilentlyContinue |
            Select-Object -ExpandProperty "Version" |
            Should -Be $Version
        }
    }
    Context "Resource Installation Tests" {
        It "Asserting Resource Is Installed @{ ModuleName = '<Name>' ; RequiredVersion = '<Version>' }" -ForEach $resources {
            Get-Module -FullyQualifiedName @{ ModuleName = $Name ; RequiredVersion = $Version } -ListAvailable |
            Should -Not -BeNullOrEmpty
        }
    }
}
