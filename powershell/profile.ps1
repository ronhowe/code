$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

Get-Date

Write-Host "Running PowerShell $($PSVersionTable.PSVersion.ToString())"

if ($PSVersionTable.PSEdition -ne "Core") {
    Write-Warning "PowerShell Core Not Detected" -WarningAction Continue
}

Write-Host "Loading Profile ; Please Wait" -ForegroundColor DarkGray

if (Get-Module -Name "Az.Tools.Predictor" -ListAvailable) {
    Import-Module -Name "Az.Tools.Predictor" -Verbose:$false
}
else {
    Write-Warning "Skipping Az.Tools.Predictor"
}

if ($host.Name -eq "Windows PowerShell ISE Host") {
    if (Get-Module -Name "ISESteroids" -ListAvailable) {
        Import-Module -Name "ISESteroids" -Verbose:$false
    }
    else {
        Write-Warning "Skipping ISESteroids"
    }
}

if (Get-Module -Name "posh-git" -ListAvailable) {
    Import-Module -Name "posh-git" -Verbose:$false
}
else {
    Write-Warning "Skipping posh-git"
}

if (Get-Module -Name "Microsoft.PowerShell.SecretManagement" -ListAvailable) {
    Import-Module -Name "Microsoft.PowerShell.SecretManagement" -Verbose:$false
}
else {
    Write-Warning "Skipping Microsoft.PowerShell.SecretManagement"
}

if (Get-Module -Name "Microsoft.PowerShell.SecretStore" -ListAvailable) {
    Import-Module -Name "Microsoft.PowerShell.SecretStore" -Verbose:$false
}
else {
    Write-Warning "Skipping Microsoft.PowerShell.SecretStore"
}

if ($host.Name -eq "Windows PowerShell ISE Host") {
    # NOTE: work configuration
    New-Variable -Name "Root" -Value "$HOME\repos" -Scope Global -Force -ErrorAction SilentlyContinue
}

if ($PSVersionTable.PSEdition -eq "Core") {
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    Set-PSReadLineOption -PredictionViewStyle ListView -WarningAction SilentlyContinue
}
else {
    Set-PSReadLineOption -PredictionViewStyle InlineView -WarningAction SilentlyContinue
}

function Get-DevOpsStatus {
    [CmdletBinding()]
    param()

    Write-Verbose "Getting DevOps Tools"
    & "$HOME\repos\ronhowe\code\powershell\prototypes\tools\Get-DevOpsTools.ps1"

    Write-Verbose "Testing Dependencies"
    & "$HOME\repos\ronhowe\code\powershell\dependencies\Invoke-Dependencies.Tests.ps1"

    ## TODO: Add .NET and PowerShell tests.
    ## TODO: Pick an Test- vs Invoke- strategy.
    ## TODO: Which to use: & or . or nothing.
    # & "$HOME\repos\ronhowe\code\powershell\dependencies\Test-Module.ps1"
    # . "$HOME\repos\ronhowe\code\powershell\prototypes\dotnet\Invoke-BuildWorkflow.ps1"

    Write-Verbose "Running .NET List"
    dotnet list $HOME\repos\ronhowe\code\dotnet\MySolution.sln package --outdated

    Write-Verbose "Running WinGet Upgrade"
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
    Write-Host "The Matrix has you..." -ForegroundColor Green
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
    Set-PSReadLineOption -PredictionViewStyle InlineView -WarningAction SilentlyContinue
}

New-Alias -Name "showinline" -Value Show-PredictionInline -Force

function Show-PredictionList {
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

Set-Location -Path $HOME

Show-RonHowe

Write-Host "https://github.com/ronhowe" -ForegroundColor Blue

Write-Host "OK" -ForegroundColor Green
