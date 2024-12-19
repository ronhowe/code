#requires -Module "Pester"

BeforeAll {
    . $PSCommandPath.Replace(".Tests.ps1", ".ps1")
}
Describe "Test-Function" {
    Context "Filter Tests" {
        It "Asserting Default Filter Returns All Values" {
            $allPlanets = Test-Function

            $allPlanets.Count |
            Should -Be 3
        }
        It "Asserting Filter Returns One Value" {
            $allPlanets = Test-Function -Name "*a*"

            $allPlanets.Count |
            Should -Be 1
        }
    }
}
