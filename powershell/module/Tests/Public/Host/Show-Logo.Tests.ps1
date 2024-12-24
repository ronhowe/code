[CmdletBinding()]
param(
)
Describe "Show-Logo Tests" {
    It "Invoke Does Not Throw" {
        { Show-Logo } |
        Should -Not -Throw
    }
    It "Invoke Returns Nothing" {
        Show-Logo |
        Should -BeNullOrEmpty
    }
}
