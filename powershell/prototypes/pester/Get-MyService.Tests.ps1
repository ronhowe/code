BeforeAll {
    . $PSCommandPath.Replace(".Tests.ps1", ".ps1")
}
Describe "Get-MyService Tests" {
    Context "Testing MyInput" {
        It "Asserting MyService Returns $false" {
            Write-Host "Asserting MyService Returns $false" -ForegroundColor Cyan
            Get-MyService -MyInput $false | Should -BeFalse
        }
        It "Asserting MyService Returns $true" {
            Write-Host "Asserting MyService Returns $true" -ForegroundColor Cyan
            Get-MyService -MyInput $true | Should -BeTrue
        }
    }
}
