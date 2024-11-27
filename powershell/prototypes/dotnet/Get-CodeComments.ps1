<###############################################################################
https://github.com/ronhowe
###############################################################################>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = "$HOME\repos\ronhowe\code\dotnet",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$Pattern = "(//help|//link|//todo)"
)
Get-ChildItem -Path $Path -Include @("*.cs", "*.json") -Recurse |
Where-Object { $_.FullName -notlike "*\bin\*" -and $_.FullName -notlike "*\obj\*" } |
Sort-Object -Property "FullName" |
Select-String -Pattern $Pattern |
Select-Object -Property @("Path", @{Name = "Line"; Expression = { $_.Line.Trim() } })
