$TestCases = @(
    Get-VM -Name "LAB*" |
    ForEach-Object { [hashtable]@{ "Node" = $_.Name } }
)
Describe "Host Configuration Tests" {
    Context "Node State" {
        It "Asserting Node <Node> Is Running" -TestCases $TestCases {
            param (
                [string]
                $Node
            )
            Write-Host "Asserting Node $Node Is Running" -ForegroundColor Cyan
            (Get-VM -Name $Node).State |
            Should -Be "Running"
        }
    }
}
