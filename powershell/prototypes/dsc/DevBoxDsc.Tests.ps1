Describe "DevBox Dsc Tests" {
    Context "Resources" {
        It "Asserting Repos Folder Exists" {
            Write-Host "Asserting Repos Folder Exists" -ForegroundColor Cyan
            Test-Path -Path (Resolve-Path "~\repos") |
            Should -BeTrue
        }
    }
}
