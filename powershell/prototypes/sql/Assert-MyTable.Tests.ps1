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
            $result = Assert-MyTable

            # assert
            $result.Result |
            Should -Be 1
        }
    }
}
