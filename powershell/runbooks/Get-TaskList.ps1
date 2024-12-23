[CmdletBinding()]
param()

## TODO: Add tasks alias to profile.
## TODO: Add abilit to filter by pattern as parameter.
Get-ChildItem -Path "$HOME\repos\ronhowe\code" -Include @("*.bicep", "*.cs", "*.json", "*.md", "*.ps*", "*.sql", "*.txt", "*.xml") -Recurse |
Where-Object { $_.FullName -notlike "*\bin\*" -and $_.FullName -notlike "*\obj\*" } |
Sort-Object -Property "FullName" |
Select-String -Pattern "(LINK|NOTE|TODO)" -CaseSensitive |
Select-Object -Property @("Path", @{Name = "Line"; Expression = { $_.Line.Trim() } }) |
Where-Object { $_.Line -notlike "*(LINK|NOTE|TODO)*" }
