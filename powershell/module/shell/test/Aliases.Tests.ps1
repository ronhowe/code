[CmdletBinding()]
param(
)
Describe "Alias Tests" {
    It "Asserting Alias [<Alias>] Exists" -ForEach @(
        @{ Alias = "catfact" }
        @{ Alias = "date" }
        @{ Alias = "help" }
        @{ Alias = "home" }
        @{ Alias = "matrix" }
        @{ Alias = "menu" }
        @{ Alias = "new" }
        @{ Alias = "oops" }
        @{ Alias = "redact" }
        @{ Alias = "repos" }
        @{ Alias = "shell" }
        @{ Alias = "time" }
        @{ Alias = "version" }
        @{ Alias = "weather" }
    ) {
        Get-Alias -Name $Alias |
        Should -Not -BeNullOrEmpty
    }
}
