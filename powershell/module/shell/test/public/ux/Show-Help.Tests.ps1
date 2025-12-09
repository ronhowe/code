[CmdletBinding()]
param(
)
Describe "Show-Help Tests" {
    It "Asserting Show Does Not Throw" {
        { Show-Help } |
        Should -Not -Throw
    }
    It "Asserting Show Returns Nothing" {
        Show-Help |
        Should -BeNullOrEmpty
    }
}
