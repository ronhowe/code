$TestCases = @(
    @{ ComputerName = "LAB-DC-00" }
    @{ ComputerName = "LAB-APP-00" }
    @{ ComputerName = "LAB-SQL-00" }
    @{ ComputerName = "LAB-WEB-00" }
)
Describe "Host Configuration Tests" {
    Context "Node State" {
        It "Asserting Node <ComputerName> Is Running" -TestCases $TestCases {
            param (
                [string]
                $ComputerName
            )
            (Get-VM -Name $ComputerName).State |
            Should -Be "Running"
        }
    }
}
