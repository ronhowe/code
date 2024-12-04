<###############################################################################
https://github.com/ronhowe
###############################################################################>

#requires -Module "Pester"
#requires -Module "SqlServer"

BeforeAll {
    . $PSCommandPath.Replace(".Tests.ps1", ".ps1")
}
Describe "Database Integration Tests" {
    Context "[localhost].[MyDatabase]" {
        It "[dbo].[MyTable] Exists" {
            # arrange

            # act
            $result = Assert-MyTableExists

            # assert
            $result.Result |
            Should -Be 1
        }
    }
}
