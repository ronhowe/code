[CmdletBinding()]
param(
)
Describe "Get-Weather Tests" {
    It "Asserting Call Returns Weather" {
        Mock -ModuleName "Shell" Invoke-Request { return "MOCK" }

        Get-Weather |
        Should -Be "MOCK"
    }
}
