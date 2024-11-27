<###############################################################################
https://github.com/ronhowe
###############################################################################>

function Get-Planet {
    param(
        [string]$Name = "*"
    )
    @(
        @{ Name = "Earth" }
        @{ Name = "Jupiter" }
        @{ Name = "Mars" }
        @{ Name = "Mercury" }
        @{ Name = "Neptune" }
        @{ Name = "Saturn" }
        @{ Name = "Uranus" }
        @{ Name = "Venus" }
    ) |
    ForEach-Object { [PSCustomObject] $_ } |
    Where-Object { $_.Name -like $Name }
}
