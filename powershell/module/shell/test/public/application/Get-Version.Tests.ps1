[CmdletBinding()]
param(
)
Describe "Get-Version Tests" {
    It "Asserting Version Is Returned" {
        Mock -ModuleName "Shell" Get-Module { return @{ Version = "M.O.C.K" } }

        Get-Version |
        Should -Be "M.O.C.K"
    }
}
