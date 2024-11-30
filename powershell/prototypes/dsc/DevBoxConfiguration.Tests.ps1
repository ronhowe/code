#requires -Module "Pester"

Describe "DevBoxConfiguration" {
    Context "ResourceTests" {
        It "ReposFolderExists" {
            Test-Path -Path "$HOME\repos" |
            Should -BeTrue
        }
    }
}
