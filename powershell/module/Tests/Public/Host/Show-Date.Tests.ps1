[CmdletBinding()]
param(
)
Describe "Show-Date Tests" {
    It "Invoke Does Not Throw" {
        { Show-Date } |
        Should -Not -Throw
    }
    It "Invoke Returns Nothing" {
        Show-Date |
        Should -BeNullOrEmpty
    }
}
