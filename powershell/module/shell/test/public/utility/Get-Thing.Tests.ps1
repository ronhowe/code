Describe "Get-Thing Tests" {
    Context "Some Tests" {
        It "Asserting Correct Count" {
            (Get-Thing).Count |
            Should -Be 2
        }
    }
}
