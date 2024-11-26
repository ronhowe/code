# sync with Aliases.ps1
# sync with Aliases.Tests.ps1
# sync with Show-Help.ps1
New-Alias -Name "catfact" -Value "Get-CatFact" -Force -Scope Global
New-Alias -Name "date" -Value "Show-Date" -Force -Scope Global
New-Alias -Name "help" -Value "Show-help" -Force -Scope Global
New-Alias -Name "logo" -Value "Show-Logo" -Force -Scope Global
New-Alias -Name "quote" -Value "Get-Quote" -Force -Scope Global
New-Alias -Name "ready" -Value "Show-Ready" -Force -Scope Global
New-Alias -Name "pshell" -Value "Start-Shell" -Scope Global -Force
New-Alias -Name "version" -Value "Show-Version" -Force -Scope Global
New-Alias -Name "weather" -Value "Get-Weather" -Force -Scope Global
