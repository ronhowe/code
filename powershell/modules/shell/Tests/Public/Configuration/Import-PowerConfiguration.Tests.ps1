# [CmdletBinding()]
# param(
#     [Parameter()]
#     [ValidateNotNullOrEmpty()]
#     [string]$Name = "Shell"
# )
# Describe "TestingImportPowerConfiguration" {
#     BeforeAll {
#         Import-Module -Name "$PSScriptRoot\..\..\..\Output\Modules\$Name" -Force
#     }
#     It "PathValidDoesNotThrow" {
#         { Import-PowerConfiguration -Name $Name -Path "$PSScriptRoot\MockPowerConfiguration.json" }
#         | Should -Not -Throw
#     }
#     It "MockConfigurationNameExists" {
#         $ShellConfiguration.MockPowerConfigurationName
#         | Should -Not -BeNullOrEmpty
#     }
#     It "MockConfigurationValueExpected" {
#         $ShellConfiguration.MockPowerConfigurationName
#         | Should -Be "MockPowerConfigurationValue"
#     }
# }