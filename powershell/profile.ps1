<###############################################################################
https://github.com/ronhowe
###############################################################################>

<#
## NOTE: This script is intended to be run in a PowerShell Core environment.
New-Item -Path $profile -Force ;
'. $HOME\repos\ronhowe\code\powershell\profile.ps1' | Set-Content -Path $profile -Force
. $profile
#>

$ProgressPreference = "SilentlyContinue"

Write-Output "https://github.com/ronhowe/code/powershell/blob/main/profile.ps1"

Write-Output "PowerShell $($PSVersionTable.PSVersion.ToString())"

Set-Location -Path $HOME

#region imports

if (Get-Module -Name "Az.Tools.Predictor" -ListAvailable) {
    Write-Output "Importing Az.Tools.Predictor"
    Import-Module -Name "Az.Tools.Predictor"
}
else {
    Write-Output "Skipping Az.Tools.Predictor"
}

if ((Get-Module -Name "ISESteroids" -ListAvailable) -and ($host.Name -eq "Windows PowerShell ISE Host")) {
    Write-Output "Importing ISESteroids"
    Import-Module -Name "ISESteroids"
}
else {
    Write-Output "Skipping ISESteroids"
}

if ((Get-Module -Name "posh-git" -ListAvailable) -and ($host.Name -ne "Visual Studio Code Host")) {
    Write-Output "Importing posh-git"
    Import-Module -Name "posh-git"
}
else {
    Write-Output "Skipping posh-git"
}

if (Get-Module -Name "Microsoft.PowerShell.SecretManagement" -ListAvailable) {
    Write-Output "Importing Microsoft.PowerShell.SecretManagement"
    Import-Module -Name "Microsoft.PowerShell.SecretManagement"
}
else {
    Write-Output "Skipping Microsoft.PowerShell.SecretManagement"
}

if (Get-Module -Name "Microsoft.PowerShell.SecretStore" -ListAvailable) {
    Write-Output "Importing Microsoft.PowerShell.SecretStore"
    Import-Module -Name "Microsoft.PowerShell.SecretStore"
}
else {
    Write-Output "Skipping Microsoft.PowerShell.SecretStore"
}

#endregion imports

if ($host.Name -eq "Windows PowerShell ISE Host") {
    # legacy build machine support
    New-Variable -Name "Root" -Value "$HOME\repos" -Scope Global -Force -ErrorAction SilentlyContinue
}
else {
    New-Variable -Name "root" -Value "$HOME\repos\ronhowe\code" -Scope Global -Force -ErrorAction SilentlyContinue
}

#region PSReadLine Configuration

## TODO: Create aliases "inlineview" and "listview" to easiliy switch.
if ($PSVersionTable.PSEdition -eq "Core") {
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    Set-PSReadLineOption -PredictionViewStyle ListView -WarningAction SilentlyContinue
}
else {
    Set-PSReadLineOption -PredictionViewStyle InlineView -WarningAction SilentlyContinue
}

#endregion PSReadLine Configuration

#region Get-UpgradeStatus (aka upgrade)

function Get-UpgradeStatus {
    . "$HOME\repos\ronhowe\code\powershell\prototypes\tools\Get-DevOpsTools.ps1"
    . "$HOME\repos\ronhowe\code\powershell\dependencies\Invoke-Dependencies.Tests.ps1"
    dotnet list .\repos\ronhowe\code\dotnet\MySolution.sln package --outdated
    winget upgrade
}

New-Alias -Name "ok" -Value Get-UpgradeStatus -Force
New-Alias -Name "upgrade" -Value Get-UpgradeStatus -Force

#endregion Get-UpgradeStatus (aka upgrade)

#region Push-LocationCode (aka go)

function Push-LocationCode {
    if (Test-Path -Path "$HOME\repos\ronhowe\code") {
        Push-Location -Path "$HOME\repos\ronhowe\code"
    }
}

New-Alias -Name "go" -Value Push-LocationCode -Force

#endregion Push-LocationHome (aka home)

#region Push-LocationHome (aka home)

function Push-LocationHome {
    Push-Location -Path $HOME
}

New-Alias -Name "home" -Value Push-LocationHome -Force

#endregion Push-LocationHome (aka home)

#region Push-LocationRepos (aka repos)

function Push-LocationRepos {
    if (Test-Path -Path "$HOME\repos") {
        Push-Location -Path "$HOME\repos"
    }
}

New-Alias -Name "repos" -Value Push-LocationRepos -Force

#endregion Push-LocationRepos (aka repos)

#region Hide-PromptMinimal (aka quiet)

function Hide-PromptMinimal {
    function global:prompt { "~> " }
}

New-Alias -Name "quiet" -Value Hide-PromptMinimal -Force

#endregion Hide-PromptMinimal (aka quiet)

#region Hide-PromptOff (aka silence)

function Hide-PromptOff {
    function global:prompt { "`0" }
}

New-Alias -Name "silence" -Value Hide-PromptOff -Force

#endregion Set-PromptOff (aka silence)

#region Open-PSReadLineHistory (aka oops)

function Open-PSReadLineHistory {
    notepad (Get-PSReadLineOption).HistorySavePath
}

New-Alias -Name "oops" -Value Open-PSReadLineHistory -Force

#endregion Open-PSReadLineHistory (aka oops)

#region Show-New (aka new)

function Show-New {
    Clear-Host
    Show-RonHowe
}

New-Alias -Name "new" -Value Show-New -Force

#endregion Show-New (aka new)

#region Show-RonHowe (aka ronhowe)

function Show-RonHowe {
    Write-Host "r" -BackgroundColor Red -ForegroundColor Black -NoNewline
    Write-Host "o" -BackgroundColor DarkYellow -ForegroundColor Black -NoNewline
    Write-Host "n" -BackgroundColor Yellow -ForegroundColor Black -NoNewline
    Write-Host "h" -BackgroundColor Green -ForegroundColor Black -NoNewline
    Write-Host "o" -BackgroundColor DarkBlue -ForegroundColor Black -NoNewline
    Write-Host "w" -BackgroundColor Blue -ForegroundColor Black -NoNewline
    Write-Host "e" -BackgroundColor Cyan -ForegroundColor Black -NoNewline
    Write-Host ".net"
}

New-Alias -Name "ronhowe" -Value Show-RonHowe -Force

#endregion Show-RonHowe (aka ronhowe)

#region Push-WslCmatrix (aka matrix)

function Invoke-WslCmatrix {
    Clear-Host
    Write-Output "The Matrix has you..."
    Start-Sleep -Seconds 3
    wsl cmatrix
}

New-Alias -Name "matrix" -Value Invoke-WslCmatrix -Force

#endregion Push-WslCmatrix (aka matrix)
