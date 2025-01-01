$TestCases = @(
    Get-VM -Name "LAB*" |
    ForEach-Object { [hashtable]@{ "Node" = $_.Name } }
)
Describe "Guest Dsc Tests" {
    Context "Network" {
        It "Asserting Ping Connectivity To <Node>" -TestCases $TestCases {
            param (
                [string]
                $Node
            )
            Write-Host "Asserting Ping Connectivity To $Node" -ForegroundColor Cyan
            (Test-NetConnection -ComputerName $Node -WarningAction SilentlyContinue).PingSucceeded |
            Should -BeTrue
        }
    }
}
$TestCases = @(
    Get-VM -Name "LAB*SQL*" |
    ForEach-Object { [hashtable]@{ "Node" = $_.Name } }
)
Describe "Guest SQL Server Tests" {
    Context "Network" {
        It "Asserting Net Connection On Port 1433 To <Node>" -TestCases $TestCases {
            param (
                [string]
                $Node
            )
            Write-Host "Asserting Net Connection On Port 1433 To $Node" -ForegroundColor Cyan
            (Test-NetConnection -ComputerName $Node -Port 1433 -WarningAction SilentlyContinue).TcpTestSucceeded |
            Should -BeTrue
        }
    }
}
$TestCases = @(
    Get-VM -Name "LAB*WEB*" |
    ForEach-Object { [hashtable]@{ "Node" = $_.Name } }
)
Describe "Guest Web Server Tests" {
    Context "Network" {
        It "Asserting Net Connection On Port 80 To <Node>" -TestCases $TestCases {
            param (
                [string]
                $Node
            )
            Write-Host "Asserting Net Connection On Port 80 To $Node" -ForegroundColor Cyan
            (Test-NetConnection -ComputerName $Node -Port 80 -WarningAction SilentlyContinue).TcpTestSucceeded |
            Should -BeTrue
        }
    }
}
