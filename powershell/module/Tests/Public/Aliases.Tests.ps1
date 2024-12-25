[CmdletBinding()]
param(
)
Describe "Alias Tests" -ForEach @(
    # sync with Aliases.ps1
    # sync with Aliases.Tests.ps1
    # sync with Show-Help.ps1
    @{ Alias = "catfact" }
    @{ Alias = "date" }
    @{ Alias = "help" }
    @{ Alias = "shell" }
    @{ Alias = "quote" }
    @{ Alias = "version" }
    @{ Alias = "weather" }
) {
    It "Asserting Alias [<Name>] Exists" -ForEach @(
        @{ Name = $Alias }
    ) {
        Get-Alias -Name $Alias |
        Should -Not -BeNullOrEmpty
    }
}
