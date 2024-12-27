function Start-Menu {
    [CmdletBinding()]
    param(
        [switch]
        $StartTranscript
    )
    begin {
        Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

        $ErrorActionPreference = "Continue"

        Write-Verbose "Removing CliMenu Module"
        Remove-Module -Name "CliMenu" -Force -ErrorAction SilentlyContinue

        Write-Verbose "Asserting CliMenu Module Exists"
        if (Get-Module -Name "CliMenu" -ListAvailable) {
            Write-Verbose "Importing CliMenu"
            Import-Module -Name "CliMenu" -Verbose:$false
        }
        else {
            Write-Error "Import Failed Becuase CliMenu Module Does Not Exist"
        }
    
        ################################################################################
        #region Menu Options

        Write-Verbose "Setting Menu Options"
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

        #endregion Menu Options
        ################################################################################

        ############################################################
        #region Common Menu Items

        $ExitMenuItem = @{
            Name           = "ExitMenuItem"
            DisplayName    = "Exit"
            Action         = { }
            DisableConfirm = $true
        }
        $ExitMenuItem = New-MenuItem @ExitMenuItem

        $MainMenuMenuItem = @{
            Name           = "MainMenuMenuItem"
            DisplayName    = "Main Menu"
            Action         = { Show-Menu }
            DisableConfirm = $true
        }
        $MainMenuMenuItem = New-MenuItem @MainMenuMenuItem

        #endregion Common Menu Items
        ############################################################

        ################################################################################
        #region Main Menu

        $parameters = @{
            Name        = "MainMenu"
            DisplayName = "Main Menu"
        }
        New-Menu @parameters |
        Out-Null

        $ExitMenuItem |
        Add-MenuItem -Menu "MainMenu"

        $parameters = @{
            Name           = "ConnectAzureAccountMenuItem"
            DisplayName    = "Connect Azure Account"
            Action         = {
                & "$HOME\repos\ronhowe\code\powershell\azure\Connect-AzureAccount.ps1" -Verbose |
                Out-Null
                Show-Menu -MenuName "MainMenu"
            }
            DisableConfirm = $false
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "MainMenu"

        $parameters = @{
            Name           = "AzureMenuMenuItem"
            DisplayName    = "Azure Menu"
            Action         = { Show-Menu -MenuName "AzureMenu" }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "MainMenu"

        $parameters = @{
            Name           = "ConfigurationMenuMenuItem"
            DisplayName    = "Configuration Menu"
            Action         = { Show-Menu -MenuName "ConfigurationMenu" }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "MainMenu"

        $parameters = @{
            Name           = "DebugMenuMenuItem"
            DisplayName    = "Debug Menu"
            Action         = { Show-Menu -MenuName "DebugMenu" }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "MainMenu"

        $parameters = @{
            Name           = "DependenciesMenuMenuItem"
            DisplayName    = "Dependencies Menu"
            Action         = { Show-Menu -MenuName "DependenciesMenu" }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "MainMenu"

        $parameters = @{
            Name           = "DevOpsMenuMenuItem"
            DisplayName    = "DevOps Menu"
            Action         = { Show-Menu -MenuName "DevOpsMenu" }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "MainMenu"

        #endregion Main Menu
        ################################################################################

        ################################################################################
        #region Azure Menu

        $parameters = @{
            Name        = "AzureMenu"
            DisplayName = "Azure Menu"
        }
        New-Menu @parameters |
        Out-Null

        $MainMenuMenuItem  |
        Add-MenuItem -Menu "AzureMenu"

        $parameters = @{
            Name           = "NewAzureResourceGroupMenuItem"
            DisplayName    = "New Azure Resource Group"
            Action         = {
                & "$HOME\repos\ronhowe\code\powershell\azure\New-AzureResourceGroup.ps1" -Verbose |
                Out-Null
                Show-Menu -MenuName "AzureMenu"
            }
            DisableConfirm = $false
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "AzureMenu"

        $parameters = @{
            Name           = "NewAzureResourceDeploymentGroupMenuItem"
            DisplayName    = "New Azure Resource Group Deployment"
            Action         = {
                & "$HOME\repos\ronhowe\code\powershell\azure\New-AzureResourceGroupDeployment.ps1" -Verbose |
                Out-Null
                Show-Menu -MenuName "AzureMenu"
            }
            DisableConfirm = $false
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "AzureMenu"

        $parameters = @{
            Name           = "RemoveAzureResourceGroupMenuItem"
            DisplayName    = "Remove Azure Resource Group"
            Action         = {
                & "$HOME\repos\ronhowe\code\powershell\azure\Remove-AzureResourceGroup.ps1" -Verbose -ErrorAction Continue |
                Out-Null
                & "$HOME\repos\ronhowe\code\powershell\azure\Clear-AzureAppConfigurationDeletedStore.ps1" -Verbose -ErrorAction Continue |
                Out-Null
                Show-Menu -MenuName "AzureMenu"
            }
            DisableConfirm = $false
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "AzureMenu"

        #endregion Azure Menu
        ################################################################################

        ################################################################################
        #region Configuration Menu

        $parameters = @{
            Name        = "ConfigurationMenu"
            DisplayName = "Configuration Menu"
        }
        New-Menu @parameters |
        Out-Null

        $MainMenuMenuItem  |
        Add-MenuItem -Menu "ConfigurationMenu"

        $parameters = @{
            Name           = "ConfigurationMenuMenuItem"
            DisplayName    = "Configuration Menu"
            Action         = {
                & "$HOME\repos\ronhowe\code\powershell\configuration\Import-ShellConfiguration.ps1" -Verbose
                Show-Menu -MenuName "ConfigurationMenu"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "ConfigurationMenu"

        #endregion Configuration Menu
        ################################################################################

        ################################################################################
        #region Debug Menu

        $parameters = @{
            Name        = "DebugMenu"
            DisplayName = "Debug Menu"
        }
        New-Menu @parameters |
        Out-Null

        $MainMenuMenuItem  |
        Add-MenuItem -Menu "DebugMenu"

        $parameters = @{
            Name           = "DebugMenuMenuItem"
            DisplayName    = "Debug Menu"
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
                Show-Menu -MenuName "DebugMenu"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "DebugMenu"

        #endregion Debug Menu
        ################################################################################

        ################################################################################
        #region Dependencies Menu

        $parameters = @{
            Name        = "DependenciesMenu"
            DisplayName = "Dependencies Menu"
        }
        New-Menu @parameters |
        Out-Null

        $MainMenuMenuItem |
        Add-MenuItem -Menu "DependenciesMenu"

        $parameters = @{
            Name           = "TestDependenciesMenuItem"
            DisplayName    = "Test Dependencies"
            Action         = {
                & "$HOME\repos\ronhowe\code\powershell\dependencies\Test-Dependencies.ps1"
                Show-Menu -MenuName "DependenciesMenu"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "DependenciesMenu"

        #endregion Dependencies Menu
        ################################################################################

        ################################################################################
        #region DevOps Menu

        $parameters = @{
            Name        = "DevOpsMenu"
            DisplayName = "DevOps Menu"
        }
        New-Menu @parameters |
        Out-Null

        $MainMenuMenuItem |
        Add-MenuItem -Menu "DevOpsMenu"

        $parameters = @{
            Name           = "GetDevOpsToolsMenuItem"
            DisplayName    = "Get DevOps Tools"
            Action         = {
                & "$HOME\repos\ronhowe\code\powershell\runbooks\Get-DevOpsTools.ps1" -Verbose
                Show-Menu -MenuName "DevOpsMenu"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "DevOpsMenu"

        $parameters = @{
            Name           = "ClearLocalStorageMenuItem"
            DisplayName    = "Clear Local Storage"
            Action         = {
                & "$HOME\repos\ronhowe\code\powershell\runbooks\Clear-LocalStorage.ps1" -Verbose
                Show-Menu -MenuName "DevOpsMenu"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "DevOpsMenu"

        $parameters = @{
            Name           = "OpenLogsFolderMenuItem"
            DisplayName    = "Open Logs Folder"
            Action         = {
                explorer.exe "$HOME\repos\ronhowe\code\logs"
                Show-Menu -MenuName "DevOpsMenu"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "DevOpsMenu"

        #endregion DevOps Menu
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
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
