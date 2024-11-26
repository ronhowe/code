$ProgressPreference = "SilentlyContinue"

Write-Host "https://github.com/ronhowe/code/powershell/blob/main/profile.ps1" -ForegroundColor Green

Write-Host "PowerShell $($PSVersionTable.PSVersion.ToString())" -ForegroundColor Green

Set-Location -Path $HOME

#region imports

if (Get-Module -Name "Az.Tools.Predictor" -ListAvailable) {
    Write-Host "Importing Az.Tools.Predictor" -ForegroundColor Green
    Import-Module -Name "Az.Tools.Predictor"
}
else {
    Write-Host "Skipping Az.Tools.Predictor" -ForegroundColor Gray
}

if ((Get-Module -Name "ISESteroids" -ListAvailable) -and ($host.Name -eq "Windows PowerShell ISE Host")) {
    Write-Host "Importing ISESteroids" -ForegroundColor Green
    Import-Module -Name "ISESteroids"
}
else {
    Write-Host "Skipping ISESteroids" -ForegroundColor Gray
}

if ((Get-Module -Name "posh-git" -ListAvailable) -and ($host.Name -ne "Visual Studio Code Host")) {
    Write-Host "Importing posh-git" -ForegroundColor Green
    Import-Module -Name "posh-git"
}
else {
    Write-Host "Skipping posh-git" -ForegroundColor Gray
}

if (Get-Module -Name "Microsoft.PowerShell.SecretManagement" -ListAvailable) {
    Write-Host "Importing Microsoft.PowerShell.SecretManagement" -ForegroundColor Green
    Import-Module -Name "Microsoft.PowerShell.SecretManagement"
}
else {
    Write-Host "Skipping Microsoft.PowerShell.SecretManagement" -ForegroundColor Gray
}

if (Get-Module -Name "Microsoft.PowerShell.SecretStore" -ListAvailable) {
    Write-Host "Importing Microsoft.PowerShell.SecretStore" -ForegroundColor Green
    Import-Module -Name "Microsoft.PowerShell.SecretStore"
}
else {
    Write-Host "Skipping Microsoft.PowerShell.SecretStore" -ForegroundColor Gray
}

#endregion imports

#region Get-UpgradeStatus (aka upgrade)

function Get-UpgradeStatus {
    . "$HOME\repos\ronhowe\powershell\tools\Get-DevOpsTools.ps1"
    . "$HOME\repos\ronhowe\powershell\shell\Test-Dependencies.ps1"
    dotnet list .\repos\ronhowe\dotnet\dotnet.sln package --outdated
    winget upgrade
}

New-Alias -Name "upgrade" -Value Get-UpgradeStatus -Force

#endregion Get-UpgradeStatus (aka upgrade)

#region Set-LocationHome (aka home)

function Set-LocationHome {
    Set-Location -Path $HOME
}

New-Alias -Name "home" -Value Set-LocationHome -Force

#endregion Set-LocationHome (aka home)

#region Set-LocationRepos (aka repos)

function Set-LocationRepos {
    if (Test-Path -Path "$HOME\repos") {
        Set-Location -Path "$HOME\repos"
    }
}

New-Alias -Name "repos" -Value Set-LocationRepos -Force

#endregion Set-LocationRepos (aka repos)

#region Set-PromptMinimal (aka quiet)

function Set-PromptMinimal {
    function global:prompt { "~> " }
}

New-Alias -Name "quiet" -Value Set-PromptMinimal -Force

#endregion Set-PromptMinimal (aka quiet)

#region Set-PromptOff (aka silence)

function Set-PromptOff {
    function global:prompt { "`0" }
}

New-Alias -Name "silence" -Value Set-PromptOff -Force

#endregion Set-PromptOff (aka silence)

#region Set-PSReadLineHistory (aka oops)

function Set-PSReadLineHistory {
    notepad (Get-PSReadLineOption).HistorySavePath
}

New-Alias -Name "oops" -Value Set-PSReadLineHistory -Force

#endregion Set-PSReadLineHistory (aka oops)

#region Show-New (aka new)

function Show-New {
    Clear-Host
    Show-RonHowe
    Set-LocationHome
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

#region Start-WslCmatrix (aka matrix)

function Start-WslCmatrix {
    Clear-Host
    Write-Host "The Matrix has you..." -ForegroundColor Green
    Start-Sleep -Seconds 3
    wsl cmatrix
}

New-Alias -Name "matrix" -Value Start-WslCmatrix -Force

#endregion Start-WslCmatrix (aka matrix)

#region PSReadLine Configuration

if ($PSVersionTable.PSEdition -eq "Core") {
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    Set-PSReadLineOption -PredictionViewStyle ListView -WarningAction SilentlyContinue
}
else {
    Set-PSReadLineOption -PredictionViewStyle InlineView -WarningAction SilentlyContinue
}

#endregion PSReadLine Configuration

# legacy build machine support
New-Variable -Name "Root" -Value "$HOME\repos" -Scope Global -Force -ErrorAction SilentlyContinue
