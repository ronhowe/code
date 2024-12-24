[CmdletBinding()]
param(
)
Describe "Get-Version Tests" {
    It "Returns Mock Version" {
        Mock -ModuleName "Shell" Get-Module { return @{ Version = "M.O.C.K" } }

        Get-Version |
        Should -Be "M.O.C.K"
    }
}
