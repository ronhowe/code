BeforeAll {
    . $PSCommandPath.Replace(".Tests.ps1", ".ps1")
}
Describe "Get-Planet" {
    Context "Filter Tests" {
        It "No Filter Returns Unfiltered Planets" {
            $allPlanets = Get-Planet

            $allPlanets.Count |
            Should -Be 8
        }
        It "Filter Returns Filtered Planet" {
            $allPlanets = Get-Planet -Name "*atur*"

            $allPlanets.Count |
            Should -Be 1
        }
    }
}
