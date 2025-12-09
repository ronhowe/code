function Start-Menu {
    [CmdletBinding()]
    param(
        [switch]
        $StartTranscript
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        $ErrorActionPreference = "Continue"

        Write-Verbose "Removing CliMenu Module"
        Remove-Module -Name "CliMenu" -Force -ErrorAction SilentlyContinue

        Write-Verbose "Asserting CliMenu Module Exists"
        if (Get-Module -Name "CliMenu" -ListAvailable) {
            Write-Verbose "Importing CliMenu"
            Import-Module -Name "CliMenu"
        }
        else {
            Write-Error "Import Failed Becuase CliMenu Module Does Not Exist"
        }

        ################################################################################
        #region Options

        Write-Host "Setting Menu Options"
        $parameters = @{
            FooterTextColor = "DarkGray"
            Heading         = "Shell Menu"
            HeadingColor    = "Blue"
            MaxWith         = 80
            MenuFillChar    = "#"
            MenuFillColor   = "DarkGreen"
            MenuNameColor   = "Yellow"
            SubHeading      = "https://github.com/ronhowe"
            SubHeadingColor = "Green"
        }
        Set-MenuOption @parameters

        #endregion Options
        ################################################################################

        ################################################################################
        #region Common

        $parameters = @{
            Name           = "Exit"
            DisplayName    = "Exit"
            Action         = {
                Show-DateTime
            }
            DisableConfirm = $true
        }
        $ExitMenuItem = New-MenuItem @parameters

        $parameters = @{
            Name           = "Main"
            DisplayName    = "Main"
            Action         = {
                Show-DateTime
                Show-Menu
            }
            DisableConfirm = $true
        }
        $MainMenuItem = New-MenuItem @parameters

        #endregion Common
        ################################################################################

        ################################################################################
        #region Main

        $parameters = @{
            Name        = "Main"
            DisplayName = "Main"
        }
        New-Menu @parameters |
        Out-Null

        $ExitMenuItem |
        Add-MenuItem -Menu "Main"

        ################################################################################
        #region Main | Azure

        $parameters = @{
            Name        = "Azure"
            DisplayName = "Azure"
        }
        New-Menu @parameters |
        Out-Null

        $parameters = @{
            Name           = "Azure"
            DisplayName    = "Azure"
            Action         = {
                Show-Menu -MenuName "Azure"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "Main"

        ################################################################################
        #region Main | Azure | *

        $MainMenuItem  |
        Add-MenuItem -Menu "Azure"

        $parameters = @{
            Name           = "ConnectAzureAccount"
            DisplayName    = "Connect"
            Action         = {
                Connect-AzureAccount -Verbose |
                Out-Null
                Get-AzContext |
                Out-String |
                Write-Host
                Show-Menu -MenuName "Azure"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "Azure"

        $parameters = @{
            Name           = "DisconnectAzureAccount"
            DisplayName    = "Disconnect"
            Action         = {
                Disconnect-AzureAccount -Verbose |
                Out-Null
                Show-Menu -MenuName "Azure"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "Azure"

        $parameters = @{
            Name           = "ShowAzureContext"
            DisplayName    = "Show"
            Action         = {
                Get-AzContext |
                Out-String |
                Write-Host
                Show-Menu -MenuName "Azure"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "Azure"

        $parameters = @{
            Name           = "SetAzureContext"
            DisplayName    = "Switch"
            Action         = {
                Set-AzContext -Subscription $(Read-Host -Prompt "Subscription") |
                Out-String |
                Write-Host
                Show-Menu -MenuName "Azure"
            }
            DisableConfirm = $false
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "Azure"

        $parameters = @{
            Name           = "MountAzureFileShare"
            DisplayName    = "Share"
            Action         = {
                Remove-PSDrive -Name $ShellConfig.DriveLetter -Force -ErrorAction Continue -Verbose
                Mount-AzureFileShare -Verbose
                Show-Menu -MenuName "Azure"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "Azure"

        $parameters = @{
            Name           = "NewAzureResourceGroup"
            DisplayName    = "New Azure Resource Group"
            Action         = {
                New-AzureResourceGroup -Verbose |
                Out-Null
                Show-Menu -MenuName "Azure"
            }
            DisableConfirm = $false
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "Azure"

        $parameters = @{
            Name           = "NewAzureResourceDeploymentGroup"
            DisplayName    = "New Azure Resource Group Deployment"
            Action         = {
                New-AzureResourceGroupDeployment -Verbose |
                Out-Null
                Show-Menu -MenuName "Azure"
            }
            DisableConfirm = $false
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "Azure"

        $parameters = @{
            Name           = "RemoveAzureResourceGroup"
            DisplayName    = "Remove Azure Resource Group"
            Action         = {
                $ErrorActionPreference = "Continue"
                $VerbosePreference = "Continue"
                Remove-AzureAutomationAccount |
                Out-Null
                Remove-AzureKeyVault |
                Out-Null
                Remove-AzureResourceGroup |
                Out-Null
                Clear-AzureAppConfigurationDeletedStore |
                Out-Null
                Show-Menu -MenuName "Azure"
            }
            DisableConfirm = $false
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "Azure"

        #endregion Main | Azure | *
        ################################################################################

        #endregion Main | Azure
        ################################################################################

        ################################################################################
        #region Main | DevOps

        $parameters = @{
            Name        = "DevOps"
            DisplayName = "DevOps"
        }
        New-Menu @parameters |
        Out-Null

        $parameters = @{
            Name           = "DevOps"
            DisplayName    = "DevOps"
            Action         = {
                Show-Menu -MenuName "DevOps"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "Main"

        ################################################################################
        #region Main | DevOps | *

        $MainMenuItem |
        Add-MenuItem -Menu "DevOps"

        $parameters = @{
            Name           = "GetDevOpsTools"
            DisplayName    = "Get DevOps Tools"
            Action         = {
                & "$HOME\repos\ronhowe\powershell\developer\Get-DevOpsTools.ps1"
                Show-Menu -MenuName "DevOps"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "DevOps"

        $parameters = @{
            Name           = "ClearLocalStorage"
            DisplayName    = "Clear Local Storage"
            Action         = {
                & "$HOME\repos\ronhowe\powershell\developer\Clear-LocalStorage.ps1"
                Show-Menu -MenuName "DevOps"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "DevOps"

        # $parameters = @{
        #     Name           = "OpenLogsFolder"
        #     DisplayName    = "Open Logs Folder"
        #     Action         = {
        #         explorer.exe "$HOME\repos\ronhowe\code\logs"
        #         Show-Menu -MenuName "DevOps"
        #     }
        #     DisableConfirm = $true
        # }
        # New-MenuItem @parameters |
        # Add-MenuItem -Menu "DevOps"

        #endregion Main | DevOps | *
        ################################################################################

        #endregion Main | DevOps
        ################################################################################

        ################################################################################
        #region Main | Help

        $parameters = @{
            Name        = "Help"
            DisplayName = "Help"
        }
        New-Menu @parameters |
        Out-Null

        $parameters = @{
            Name           = "Help"
            DisplayName    = "Help"
            Action         = {
                Show-Menu -MenuName "Help"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "Main"

        ################################################################################
        #region Main | Help | *

        $MainMenuItem |
        Add-MenuItem -Menu "Help"

        ################################################################################
        #region Main | Help | Configuration

        $parameters = @{
            Name        = "Configuration"
            DisplayName = "Configuration"
        }
        New-Menu @parameters |
        Out-Null

        $parameters = @{
            Name           = "Configuration"
            DisplayName    = "Configuration"
            Action         = {
                Show-Menu -MenuName "Configuration"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "Help"

        ################################################################################
        #region Main | Help | Configuration | *

        $MainMenuItem  |
        Add-MenuItem -Menu "Configuration"

        $parameters = @{
            Name           = "ShowShellConfiguration"
            DisplayName    = "Show"
            Action         = {
                Show-ShellConfiguration
                Show-Menu -MenuName "Configuration"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "Configuration"

        $parameters = @{
            Name           = "NewShellConfiguration"
            DisplayName    = "New"
            Action         = {
                New-ShellConfiguration
                Show-Menu -MenuName "Configuration"
            }
            DisableConfirm = $false
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "Configuration"

        $parameters = @{
            Name           = "OpenShellConfiguration"
            DisplayName    = "Open"
            Action         = {
                Open-ShellConfiguration
                Show-Menu -MenuName "Configuration"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "Configuration"

        $parameters = @{
            Name           = "ImportShellConfiguration"
            DisplayName    = "Import"
            Action         = {
                Import-ShellConfiguration |
                Out-Null
                Show-ShellConfiguration
                Show-Menu -MenuName "Configuration"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "Configuration"

        #endregion Main | Help | Configuration | *
        ################################################################################

        #endregion Main | Help | Configuration
        ################################################################################

        ################################################################################
        #region Main | Help | Dependencies

        $parameters = @{
            Name        = "Dependencies"
            DisplayName = "Dependencies"
        }
        New-Menu @parameters |
        Out-Null

        $parameters = @{
            Name           = "Dependencies"
            DisplayName    = "Dependencies"
            Action         = {
                Show-Menu -MenuName "Dependencies"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "Help"

        ################################################################################
        #region Main | Help | Dependencies | *

        $MainMenuItem |
        Add-MenuItem -Menu "Dependencies"

        $parameters = @{
            Name           = "TestDependencies"
            DisplayName    = "Test"
            Action         = {
                & "$HOME\repos\ronhowe\powershell\dependency\module\Test-Modules.ps1"
                Show-Menu -MenuName "Dependencies"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "Dependencies"

        $parameters = @{
            Name           = "InstallDependencies"
            DisplayName    = "Install"
            Action         = {
                & "$HOME\repos\ronhowe\powershell\dependency\module\Install-Modules.ps1"
                Show-Menu -MenuName "Dependencies"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "Dependencies"

        #endregion Main | Help | Dependencies
        ################################################################################

        #endregion Main | Help | Dependencies
        ################################################################################

        $parameters = @{
            Name           = "Debug"
            DisplayName    = "Debug"
            Action         = {
                Write-Host "## Write-Host" # visible
                Write-Debug "## Write-Debug" # visible if $DebugPreference = "Continue"
                Write-Debug "## Write-Debug -Debug" -Debug # visible
                Write-Verbose "## Write-Verbose" # visible if $VerbosePreference = "Continue"
                Write-Verbose "## Write-Verbose -Verbose" -Verbose # visible
                Write-Output "## Write-Output" # visible after (to pipeline)
                pwsh --version # visible after (to pipeline)
                Write-Host $(pwsh --version) # visible
                Write-Debug $(pwsh --version) -Debug # visible
                Write-Verbose $(pwsh --version) -Verbose # visible
                $(pwsh --version) |
                Out-String |
                Write-Verbose -Verbose
                Show-Menu -MenuName "Help"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "Help"

        #endregion Main | Help | *
        ################################################################################

        #endregion Main | Help
        ################################################################################

        $parameters = @{
            Name           = "Clock"
            DisplayName    = "Clock"
            Action         = {
                Show-DateTime
                Show-Menu -MenuName "Main"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "Main"

        #endregion Main
        ################################################################################

        Clear-Host

        if ($StartTranscript) {
            try {
                Write-Verbose "Stopping Transcript"
                Stop-Transcript -ErrorAction SilentlyContinue
            }
            catch {
            }
            finally {
                Write-Verbose "Starting Transcript"
                Start-Transcript
            }
        }

        Write-Verbose "Showing Menu"
        Show-Menu -Verbose:$false

        Write-Verbose "Removing CliMenu Module"
        Remove-Module -Name "CliMenu" -Force -ErrorAction SilentlyContinue

        Write-Verbose "Stopping Transcript"
        try {
            Write-Verbose "Stopping Transcript"
            Stop-Transcript -ErrorAction SilentlyContinue
        }
        catch {
        }
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}

New-Alias -Name "menu" -Value "Start-Menu" -Force -Scope Global
