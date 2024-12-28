[CmdletBinding()]
param(
)
begin {
    Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

    Write-Host "Loading Profile ; Please Wait" -ForegroundColor DarkGray

    $ErrorActionPreference = "Stop" # changed from Continue
    $ProgressPreference = "SilentlyContinue" # changed from Continue

    Write-Verbose "Asserting PowerShell Core"
    if ($PSVersionTable.PSEdition -ne "Core") {
        Write-Warning "PowerShell Core Not Detected"
    }

    Write-Verbose "Asserting Az.Tools.Predictor Module Exists"
    if (Get-Module -Name "Az.Tools.Predictor" -ListAvailable) {
        Write-Verbose "Importing Az.Tools.Predictor"
        Import-Module -Name "Az.Tools.Predictor" -Verbose:$false
    }
    else {
        Write-Warning "Skipping Az.Tools.Predictor Module"
    }

    Write-Verbose "Asserting Microsoft.PowerShell.SecretManagement Module Exists"
    if (Get-Module -Name "Microsoft.PowerShell.SecretManagement" -ListAvailable) {
        Write-Verbose "Importing Az.Tools.Predictor"
        Import-Module -Name "Microsoft.PowerShell.SecretManagement" -Verbose:$false
    }
    else {
        Write-Warning "Skipping Microsoft.PowerShell.SecretManagement Module"
    }

    Write-Verbose "Asserting Microsoft.PowerShell.SecretStore Module Exists"
    if (Get-Module -Name "Microsoft.PowerShell.SecretStore" -ListAvailable) {
        Write-Verbose "Importing Az.Tools.Predictor"
        Import-Module -Name "Microsoft.PowerShell.SecretStore" -Verbose:$false
    }
    else {
        Write-Warning "Skipping Microsoft.PowerShell.SecretStore Module"
    }

    Write-Verbose "Asserting posh-git Module Exists"
    if (Get-Module -Name "posh-git" -ListAvailable) {
        Write-Verbose "Importing Az.Tools.Predictor"
        Import-Module -Name "posh-git" -Verbose:$false
    }
    else {
        Write-Warning "Skipping posh-git"
    }

    ## NOTE: Work shim.
    Write-Verbose "Asserting Windows PowerShell ISE Host"
    if ($host.Name -eq "Windows PowerShell ISE Host") {
        Write-Verbose "Asserting ISESteroids Module Exists"
        if (Get-Module -Name "ISESteroids" -ListAvailable) {
            Write-Verbose "Importing ISESteroids"
            Import-Module -Name "ISESteroids" -Verbose:$false
        }
        else {
            Write-Warning "Skipping ISESteroids Module"
        }
    }

    ## NOTE: Work shims.
    Write-Verbose "Defining Global Variables"
    New-Variable -Name "Repos" -Value "$HOME\repos" -Scope Global -Force -ErrorAction SilentlyContinue
    New-Variable -Name "Root" -Value "$HOME\repos" -Scope Global -Force -ErrorAction SilentlyContinue
    New-Variable -Name "VSTS" -Value "$HOME\repos" -Scope Global -Force -ErrorAction SilentlyContinue

    Write-Verbose "Setting PSReadLine Options"
    if ($PSVersionTable.PSEdition -eq "Core") {
        Set-PSReadLineOption -PredictionSource HistoryAndPlugin
        Set-PSReadLineOption -PredictionViewStyle ListView -WarningAction SilentlyContinue
    }
    else {
        Set-PSReadLineOption -PredictionViewStyle InlineView -WarningAction SilentlyContinue
    }

    Write-Verbose "Asserting Shell Module Exists"
    if (Test-Path -Path "$HOME\repos\ronhowe\code\powershell\module\bin\Shell\Shell.psm1") {
        Write-Verbose "Removing Shell Module"
        Get-Module -Name "Shell" |
        Remove-Module -Force

        Write-Verbose "Importing Shell Module"
        Import-Module -Name "$HOME\repos\ronhowe\code\powershell\module\bin\Shell" -Force
    
        Write-Verbose "Starting Shell"
        Start-Shell
    }
    else {
        Write-Warning "Shell Module Not Found"
    }
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
