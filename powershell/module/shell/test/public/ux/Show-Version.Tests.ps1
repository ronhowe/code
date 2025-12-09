[CmdletBinding()]
param(
)
Describe "Show-Version Tests" {
    It "Asserting Show Does Not Throw" {
        { Show-Version } |
        Should -Not -Throw
    }
    It "Asserting Show Returns Nothing" {
        Show-Version |
        Should -BeNullOrEmpty
    }
}
