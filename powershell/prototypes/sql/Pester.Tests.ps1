<###############################################################################
https://github.com/ronhowe
###############################################################################>

#requires -Module "Pester"
#requires -Module "SqlServer"

Describe "Database Integration Tests" {
    Context "[localhost].[MyDatabase]" {
        It "[dbo].[MyTable] Exists" {
            $parameters = @{
                ServerInstance = "localhost"
                Database       = "MyDatabase"
                Encrypt        = "Optional"
                InputFile      = "$HOME\repos\ronhowe\code\sql\MySolution\Assert-MyTableExists.sql"
                QueryTimeout   = 100
            }
            $result = Invoke-SqlCmd @parameters

            $result.Result |
            Should -Be 1
        }
    }
}
