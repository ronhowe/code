[CmdletBinding()]
param(
)
Describe "Alias Tests" -ForEach @(
    # sync with Aliases.ps1
    # sync with Aliases.Tests.ps1
    # sync with Show-Help.ps1
    # @{ Alias = "api" }
    @{ Alias = "catfact" }
    @{ Alias = "date" }
    @{ Alias = "go" }
    @{ Alias = "header" }
    @{ Alias = "help" }
    @{ Alias = "home" }
    @{ Alias = "line" }
    @{ Alias = "list" }
    @{ Alias = "logo" }
    @{ Alias = "matrix" }
    @{ Alias = "new" }
    @{ Alias = "ok" }
    @{ Alias = "oops" }
    # @{ Alias = "pong" }
    @{ Alias = "quiet" }
    @{ Alias = "repos" }
    @{ Alias = "ronhowe" }
    @{ Alias = "shell" }
    @{ Alias = "silence" }
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
