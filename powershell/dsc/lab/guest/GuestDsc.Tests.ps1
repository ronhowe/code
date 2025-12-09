Describe "Guest Dsc Tests" {
    Context "Network Tests" {
        It "Asserting Ping Connectivity To <Name>" -ForEach ` @(
            Get-VM -Name "LAB*" |
            ForEach-Object { [hashtable]@{ "Name" = $_.Name } }
        ) {
            (Test-NetConnection -ComputerName $Name -WarningAction SilentlyContinue).PingSucceeded |
            Should -BeTrue
        }
    }
    Context "RDP Tests" {
        It "Asserting RDP Connectivity On Poprt 3389 To <Name>" -ForEach ` @(
            Get-VM -Name "LAB*" |
            ForEach-Object { [hashtable]@{ "Name" = $_.Name } }
        ) {
            (Test-NetConnection -ComputerName $Name -Port 3389 -WarningAction SilentlyContinue).TcpTestSucceeded |
            Should -BeTrue
        }
    }
    Context "WinRM Tests" {
        It "Asserting WinRM Connectivity On Port 5985 To <Name>" -ForEach ` @(
            Get-VM -Name "LAB*" |
            ForEach-Object { [hashtable]@{ "Name" = $_.Name } }
        ) {
            (Test-NetConnection -ComputerName $Name -Port 5985 -WarningAction SilentlyContinue).TcpTestSucceeded |
            Should -BeTrue
        }
        ## TODO: Enable HTTPS Listener On Port 5986
        # It "Asserting WinRM Connectivity On Port 5986 To <Name>" -ForEach ` @(
        #     Get-VM -Name "LAB*" |
        #     ForEach-Object { [hashtable]@{ "Name" = $_.Name } }
        # ) {
        #     (Test-NetConnection -ComputerName $Name -Port 5986 -WarningAction SilentlyContinue).TcpTestSucceeded |
        #     Should -BeTrue
        # }
    }
    Context "SQL Tests" {
        It "Asserting SQL Connectivity On Port 1433 To <Name>" -ForEach ` @(
            Get-VM -Name "LAB*SQL*" |
            ForEach-Object { [hashtable]@{ "Name" = $_.Name } }
        ) {
            (Test-NetConnection -ComputerName $Name -Port 1433 -WarningAction SilentlyContinue).TcpTestSucceeded |
            Should -BeTrue
        }
    }
    Context "Web Tests" {
        It "Asserting HTTP Connectivity On Port 80 To <Name>" -ForEach ` @(
            Get-VM -Name "LAB*WEB*" |
            ForEach-Object { [hashtable]@{ "Name" = $_.Name } }
        ) {
            (Test-NetConnection -ComputerName $Name -Port 80 -WarningAction SilentlyContinue).TcpTestSucceeded |
            Should -BeTrue
        }
    }
}
