[CmdletBinding()]
param(
)
Describe "Import-ShellConfiguration Tests" {
    ## TODO: Add tests for default configuration.
    It "Asserting Import Does Not Throw" {
        { Import-ShellConfiguration -Path "$PSScriptRoot\MockPowerConfiguration.json" } |
        Should -Not -Throw
    }
    It "Asserting Import Is Not Null Or Empty" {
        Import-ShellConfiguration -Path "$PSScriptRoot\MockPowerConfiguration.json" |
        Should -Not -BeNullOrEmpty
    }
    It "Asserting Mock Email Configuration" {
        (Import-ShellConfiguration -Path "$PSScriptRoot\MockPowerConfiguration.json").Email |
        Should -Be "MOCKUSER@MOCKDOMAIN.COM"
    }
    It "Asserting Mock Name Configuration" {
        (Import-ShellConfiguration -Path "$PSScriptRoot\MockPowerConfiguration.json").Name |
        Should -Be "MOCKNAME"
    }
    It "Asserting Mock Organization Configuration" {
        (Import-ShellConfiguration -Path "$PSScriptRoot\MockPowerConfiguration.json").Organization |
        Should -Be "MOCKORAGNIZATION"
    }
    It "Asserting Mock TenantId Configuration" {
        (Import-ShellConfiguration -Path "$PSScriptRoot\MockPowerConfiguration.json").TenantId |
        Should -Be "FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF"
    }
    It "Asserting Mock SubscriptionId Configuration" {
        (Import-ShellConfiguration -Path "$PSScriptRoot\MockPowerConfiguration.json").SubscriptionId |
        Should -Be "FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF"
    }
    ## TODO: Assert mock Azure configurations.
    afterall{
        Import-ShellConfiguration
    }
}
