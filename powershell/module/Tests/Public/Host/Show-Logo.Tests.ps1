[CmdletBinding()]
param(
)
Describe "Show-Logo Tests" {
    It "Asserting Show Does Not Throw" {
        { Show-Logo } |
        Should -Not -Throw
    }
    It "Asserting Show Returns Nothing" {
        Show-Logo |
        Should -BeNullOrEmpty
    }
}
