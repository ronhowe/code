# sync with Aliases.ps1
# sync with Aliases.Tests.ps1
# sync with Show-Help.ps1
# New-Alias -Name "api" -Value "Invoke-ApiTest" -Force
New-Alias -Name "catfact" -Value "Get-CatFact" -Force -Scope Global
New-Alias -Name "date" -Value "Show-Date" -Force -Scope Global
New-Alias -Name "go" -Value "Push-LocationCode" -Force -Scope Global
New-Alias -Name "header" -Value "Show-Header" -Force -Scope Global
New-Alias -Name "help" -Value "Show-Help" -Force -Scope Global
New-Alias -Name "home" -Value "Push-LocationHome" -Force -Scope Global
New-Alias -Name "line" -Value "Set-PredictionInline" -Force -Scope Global
New-Alias -Name "list" -Value "Set-PredictionList" -Force -Scope Global
New-Alias -Name "logo" -Value "Show-Logo" -Force -Scope Global
New-Alias -Name "matrix" -Value "Invoke-WslCmatrix" -Force -Scope Global
New-Alias -Name "menu" -Value "Start-Menu" -Force -Scope Global
New-Alias -Name "new" -Value "Show-New" -Force -Scope Global
New-Alias -Name "oops" -Value "Open-PSReadLineHistory" -Force -Scope Global
New-Alias -Name "quiet" -Value "Hide-PromptMinimal" -Force -Scope Global
New-Alias -Name "repos" -Value "Push-LocationRepos" -Force -Scope Global
New-Alias -Name "shell" -Value "Start-Shell" -Scope Global -Force
New-Alias -Name "silence" -Value "Hide-PromptOff" -Force -Scope Global
New-Alias -Name "version" -Value "Show-Version" -Force -Scope Global
New-Alias -Name "weather" -Value "Get-Weather" -Force -Scope Global
