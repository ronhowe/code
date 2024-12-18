$ErrorActionPreference = "Stop"
Write-Output "Running $($MyInvocation.MyCommand.Name)"

## TODO: Add tasks alias to profile.
Write-Output "Getting Task List"
Get-ChildItem -Path "$HOME\repos\ronhowe\code" -Include @("*.bicep", "*.cs", "*.json", "*.ps*", "*.sql", "*.txt", "*.xml") -Recurse |
Where-Object { $_.FullName -notlike "*\bin\*" -and $_.FullName -notlike "*\obj\*" } |
Sort-Object -Property "FullName" |
Select-String -Pattern "(LINK|NOTE|TODO)" -CaseSensitive |
Select-Object -Property @("Path", @{Name = "Line"; Expression = { $_.Line.Trim() } })
