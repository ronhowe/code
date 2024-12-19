#requires -Module "Pester"

BeforeAll {
    . $PSCommandPath.Replace(".Tests.ps1", ".ps1")
}
Describe "Test-Function Tests" {
    Context "Testing Filters" {
        It "Asserting Default Filter Returns All Values" {
            $results = Test-Function

            $results.Count |
            Should -Be 3
        }
        It "Asserting Filter Returns One Value" {
            $results = Test-Function -Name "*a*"

            $results.Count |
            Should -Be 1
        }
    }
}
