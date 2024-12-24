[CmdletBinding()]
param(
)
Describe "Show-Ready Tests" {
    It "Invoke Does Not Throw" {
        { Show-Ready } |
        Should -Not -Throw
    }
    It "Invoke Returns Nothing" {
        Show-Ready |
        Should -BeNullOrEmpty
    }
}
