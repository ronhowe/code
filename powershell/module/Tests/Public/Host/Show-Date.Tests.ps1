[CmdletBinding()]
param(
)
Describe "Show-Date Tests" {
    It "Asserting Show Does Not Throw" {
        { Show-Date } |
        Should -Not -Throw
    }
    It "Asserting Show Returns Nothing" {
        Show-Date |
        Should -BeNullOrEmpty
    }
}
