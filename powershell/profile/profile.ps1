[CmdletBinding()]
param(
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Host "Loading Profile ; Please Wait" -ForegroundColor DarkGray

    Write-Verbose "Asserting PowerShell Core"
    if ($PSVersionTable.PSEdition -ne "Core") {
        Write-Warning "PowerShell Core Not Detected"
    }

    # Write-Verbose "Asserting Az.Accounts Module Exists"
    # if (Get-Module -Name "Az.Accounts" -ListAvailable) {
    #     Write-Verbose "Importing Az.Accounts"
    #     Import-Module -Name "Az.Accounts"
    # }
    # else {
    #     Write-Warning "Skipping Az.Accounts Module"
    # }

    # Write-Verbose "Asserting Az.Resources Module Exists"
    # if (Get-Module -Name "Az.Resources" -ListAvailable) {
    #     Write-Verbose "Importing Az.Resources"
    #     Import-Module -Name "Az.Resources"
    # }
    # else {
    #     Write-Warning "Skipping Az.Resources Module"
    # }

    # Write-Verbose "Asserting Az.Tools.Predictor Module Exists"
    # if (Get-Module -Name "Az.Tools.Predictor" -ListAvailable) {
    #     Write-Verbose "Importing Az.Tools.Predictor"
    #     Import-Module -Name "Az.Tools.Predictor"
    # }
    # else {
    #     Write-Warning "Skipping Az.Tools.Predictor Module"
    # }

    Write-Verbose "Asserting Microsoft.PowerShell.SecretManagement Module Exists"
    if (Get-Module -Name "Microsoft.PowerShell.SecretManagement" -ListAvailable) {
        Write-Verbose "Importing Microsoft.PowerShell.SecretManagement"
        Import-Module -Name "Microsoft.PowerShell.SecretManagement"
    }
    else {
        Write-Warning "Skipping Microsoft.PowerShell.SecretManagement Module"
    }

    Write-Verbose "Asserting Microsoft.PowerShell.SecretStore Module Exists"
    if (Get-Module -Name "Microsoft.PowerShell.SecretStore" -ListAvailable) {
        Write-Verbose "Importing Microsoft.PowerShell.SecretStore"
        Import-Module -Name "Microsoft.PowerShell.SecretStore"
    }
    else {
        Write-Warning "Skipping Microsoft.PowerShell.SecretStore Module"
    }

    Write-Verbose "Asserting PackageManagement Module Exists"
    if (Get-Module -Name "PackageManagement" -ListAvailable) {
        Write-Verbose "Importing PackageManagement"
        Import-Module -Name "PackageManagement"
    }
    else {
        Write-Warning "Skipping PackageManagement Module"
    }

    ## NOTE: Loaded by usual hosts automatically.  Importing intentionally just for clarity.
    Write-Verbose "Asserting Pester Module Exists"
    if (Get-Module -Name "Pester" -ListAvailable) {
        Write-Verbose "Importing Pester"
        Import-Module -Name "Pester"
    }
    else {
        Write-Warning "Skipping Pester Module"
    }

    Write-Verbose "Asserting posh-git Module Exists"
    if (Get-Module -Name "posh-git" -ListAvailable) {
        Write-Verbose "Importing posh-git"
        Import-Module -Name "posh-git"
    }
    else {
        Write-Warning "Skipping posh-git Module"
    }

    Write-Verbose "Asserting Shell Module Exists"
    if (Test-Path -Path "$PSScriptRoot\..\module\shell\bin\Shell\Shell.psm1") {
        Write-Verbose "Removing Shell Module"
        Get-Module -Name "Shell" |
        Remove-Module -Force

        Write-Verbose "Importing Shell Module"
        Import-Module -Name "$PSScriptRoot\..\module\shell\bin\Shell" -Global -Force
    
        Write-Verbose "Starting Shell"
        Start-Shell
    }
    else {
        Write-Warning "Shell Module Not Found"
    }

    ## NOTE: Work shim.
    Write-Verbose "Asserting Windows PowerShell ISE Host"
    if ($host.Name -eq "Windows PowerShell ISE Host") {
        Write-Verbose "Asserting ISESteroids Module Exists"
        if (Get-Module -Name "ISESteroids" -ListAvailable) {
            Write-Verbose "Importing ISESteroids"
            Import-Module -Name "ISESteroids"
        }
        else {
            Write-Warning "Skipping ISESteroids Module"
        }
    }

    ## NOTE: Work shim.
    Write-Verbose "Defining Shim Global Variables"
    New-Variable -Name "Root" -Value "C:\VSTS" -Scope Global -Force -ErrorAction SilentlyContinue
    Write-Debug "`$Root = $Root"
    New-Variable -Name "VSTS" -Value "C:\VSTS" -Scope Global -Force -ErrorAction SilentlyContinue
    Write-Debug "`$VSTS = $VSTS"

    Write-Verbose "Setting PSReadLine Options"
    if ($PSVersionTable.PSEdition -eq "Core") {
        Set-PSReadLineOption -PredictionSource HistoryAndPlugin
        Set-PSReadLineOption -PredictionViewStyle ListView -WarningAction SilentlyContinue
    }
    else {
        Set-PSReadLineOption -PredictionViewStyle InlineView -WarningAction SilentlyContinue
    }

    Write-Verbose "Setting Location"
    Set-Location -Path $HOME
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
