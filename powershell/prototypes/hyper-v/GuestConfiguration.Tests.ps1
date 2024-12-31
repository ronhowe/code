$TestCases = @(
    @{ ComputerName = "LAB-DC-00" }
    @{ ComputerName = "LAB-APP-00" }
    @{ ComputerName = "LAB-SQL-00" }
    @{ ComputerName = "LAB-WEB-00" }
)
Describe "Networking Tests" {
    Context "Firewall" {
        It "<ComputerName> Can Be Pinged" -TestCases $TestCases {
            param (
                [string]
                $ComputerName
            )
            (Test-NetConnection -ComputerName $ComputerName -WarningAction SilentlyContinue).PingSucceeded |
            Should -BeTrue
        }
    }
}
Describe "SQL Server Tests" {
    Context "Endpoint" {
        It "SQL-VM SQL Port Open" {
            (Test-NetConnection -ComputerName "LAB-SQL-00" -Port 1433 -WarningAction SilentlyContinue).TcpTestSucceeded |
            Should -BeTrue
        }
    }
}
Describe "Web Server Tests" {
    Context "Endpoint" {
        It "WEB-VM HTTPS Port Open" {
            (Test-NetConnection -ComputerName "LAB-WEB-00" -Port 443 -WarningAction SilentlyContinue).TcpTestSucceeded | Should
            -BeTrue
        }
    }
}
