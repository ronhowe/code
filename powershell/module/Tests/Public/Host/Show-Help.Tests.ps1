[CmdletBinding()]
param(
)
Describe "Show-Help Tests" {
    It "Invoke Does Not Throw" {
        { Show-Help } |
        Should -Not -Throw
    }
    It "Invoke Returns Nothing" {
        Show-Help |
        Should -BeNullOrEmpty
    }
}
