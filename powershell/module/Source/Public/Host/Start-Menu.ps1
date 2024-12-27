function Start-Menu {
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

        $parameters = @{
            Name           = "OpenLogsFolderMenuItem"
            DisplayName    = "Open Logs Folder"
            Action         = {
                explorer.exe "$HOME\repos\ronhowe\code\logs"
                Show-Menu -MenuName "MainMenu"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "MainMenu"

        #endregion Main Menu
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
                dotnet --version # visible after (to pipeline)
                Write-Host $(pwsh --version) # visible
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
            Name           = "GetDevOpsStatusMenuItem"
            DisplayName    = "Get DevOps Status"
            Action         = {
                & "$HOME\repos\ronhowe\code\powershell\runbooks\Get-DevOpsStatus.ps1" -Verbose
                Show-Menu -MenuName "DevOpsMenu"
            }
            DisableConfirm = $true
        }
        New-MenuItem @parameters |
        Add-MenuItem -Menu "DevOpsMenu"

        #endregion DevOps Menu
        ################################################################################

        Clear-Host

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
