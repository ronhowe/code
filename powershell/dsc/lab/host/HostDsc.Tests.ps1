Describe "Host Configuration Tests" {
    It "Asserting Node <Name> Is Running" -ForEach `
    $(
        Get-VM -Name "LAB*" |
        Sort-Object -Property "Name" |
        ForEach-Object { [hashtable]@{ "Name" = $_.Name } }

    ) {
        (Get-VM -Name $Name).State |
        Should -Be "Running"
    }
}
