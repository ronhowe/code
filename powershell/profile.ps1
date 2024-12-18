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

if ($host.Name -eq "Windows PowerShell ISE Host") {
    # legacy build machine support
    New-Variable -Name "Root" -Value "$HOME\repos" -Scope Global -Force -ErrorAction SilentlyContinue
}
else {
    New-Variable -Name "root" -Value "$HOME\repos\ronhowe\code" -Scope Global -Force -ErrorAction SilentlyContinue
}

if ($PSVersionTable.PSEdition -eq "Core") {
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    Set-PSReadLineOption -PredictionViewStyle ListView -WarningAction SilentlyContinue
}
else {
    Set-PSReadLineOption -PredictionViewStyle InlineView -WarningAction SilentlyContinue
}

function Get-DevOpsStatus {
    ## TODO: Which to use: & or . or nothing.
    Write-Output "Getting DevOps Tools"
    & "$HOME\repos\ronhowe\code\powershell\prototypes\tools\Get-DevOpsTools.ps1"

    Write-Output "Testing Dependencies"
    & "$HOME\repos\ronhowe\code\powershell\dependencies\Invoke-Dependencies.Tests.ps1"

    Write-Output "Running .NET List"
    dotnet list $HOME\repos\ronhowe\code\dotnet\MySolution.sln package --outdated

    Write-Output "Running WinGet Upgrade"
    winget upgrade
}

New-Alias -Name "ok" -Value Get-DevOpsStatus -Force

function Hide-PromptMinimal {
    function global:prompt { "~> " }
}

New-Alias -Name "quiet" -Value Hide-PromptMinimal -Force

function Hide-PromptOff {
    function global:prompt { "`0" }
}

New-Alias -Name "silence" -Value Hide-PromptOff -Force


function Invoke-WslCmatrix {
    Clear-Host
    Write-Output "The Matrix has you..."
    Start-Sleep -Seconds 3
    wsl cmatrix
}

New-Alias -Name "matrix" -Value Invoke-WslCmatrix -Force

function Open-PSReadLineHistory {
    notepad (Get-PSReadLineOption).HistorySavePath
}

New-Alias -Name "oops" -Value Open-PSReadLineHistory -Force

function Push-LocationCode {
    if (Test-Path -Path "$HOME\repos\ronhowe\code") {
        Push-Location -Path "$HOME\repos\ronhowe\code"
    }
}

New-Alias -Name "go" -Value Push-LocationCode -Force

function Push-LocationHome {
    Push-Location -Path $HOME
}

New-Alias -Name "home" -Value Push-LocationHome -Force

function Push-LocationRepos {
    if (Test-Path -Path "$HOME\repos") {
        Push-Location -Path "$HOME\repos"
    }
}

New-Alias -Name "repos" -Value Push-LocationRepos -Force

function Show-New {
    Clear-Host
    Show-RonHowe
}

New-Alias -Name "new" -Value Show-New -Force

function Show-PredictionInline {
    Write-Output "Setting Prediction View Style To Inline"
    Set-PSReadLineOption -PredictionViewStyle InlineView -WarningAction SilentlyContinue
}

New-Alias -Name "showinline" -Value Show-PredictionInline -Force

function Show-PredictionList {
    Write-Output "Setting Prediction View Style To ListView"
    Set-PSReadLineOption -PredictionViewStyle ListView -WarningAction SilentlyContinue
}

New-Alias -Name "showlist" -Value Show-PredictionList -Force

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
