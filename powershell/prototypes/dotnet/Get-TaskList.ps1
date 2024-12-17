<###############################################################################
https://github.com/ronhowe
###############################################################################>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = "$HOME\repos\ronhowe\code",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$Pattern = "(LINK|NOTE|TODO)"
)
## TODO: Refactor -Include as input parameter with a default.
## TODO: Add tasks alias to profile.
Get-ChildItem -Path $Path -Include @("*.bicep", "*.cs", "*.json", "*.ps*", "*.sql", "*.txt", "*.xml") -Recurse |
Where-Object { $_.FullName -notlike "*\bin\*" -and $_.FullName -notlike "*\obj\*" } |
Sort-Object -Property "FullName" |
Select-String -Pattern $Pattern -CaseSensitive |
Select-Object -Property @("Path", @{Name = "Line"; Expression = { $_.Line.Trim() } })
