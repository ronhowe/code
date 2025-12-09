BeforeAll {
    . $PSCommandPath.Replace(".Tests.ps1", ".ps1")
}
Describe "New-Template Tests" {
    Context "Input Tests" {
        It "Asserting Name Accepts Valid Characters" {
            { New-Template -Name "John" } |
            Should -Not -Throw
        }
        It "Asserting Name Rejects Invalid Characters" {
            { New-Template -Name "John!" } |
            Should -Throw
        }
    }
    Context "Output Tests" {
        It "Asserting Output Same As Input" {
            $computerNames = @("Computer1", "Computer2", "Computer3")
            $expectedOutput = @("COMPUTER1", "COMPUTER2", "COMPUTER3")

            $result = New-Template -Name "Test" -ComputerName $computerNames

            $result |
            Should -Be $expectedOutput
        }
    }
}
