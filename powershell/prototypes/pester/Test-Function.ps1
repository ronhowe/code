function Test-Function {
    param(
        [string]$Name = "*"
    )
    @(
        @{ Name = "a" }
        @{ Name = "b" }
        @{ Name = "c" }
    ) |
    ForEach-Object { [PSCustomObject] $_ } |
    Where-Object { $_.Name -like $Name }
}
