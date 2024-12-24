[CmdletBinding()]
param(
)
Describe "Get-CatFact Tests" {
    It "Asserting Call Returns Fact" {
        Mock -ModuleName "Shell" Invoke-Request { return "[{'fact':'MOCK CAT FACT','length':13}]" }

        Get-CatFact |
        Should -Be "MOCK CAT FACT"
    }
}
