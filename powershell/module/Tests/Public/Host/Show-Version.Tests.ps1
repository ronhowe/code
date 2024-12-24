[CmdletBinding()]
param(
)
Describe "Show-Version Tests" {
    It "Invoke Does Not Throw" {
        { Show-Version } |
        Should -Not -Throw
    }
    It "Invoke Returns Nothing" {
        Show-Version |
        Should -BeNullOrEmpty
    }
}
