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
        Write-Debug "Process $($MyInvocation.MyCommand.Name)"

        Clear-Host

        Write-Verbose "Starting Transcript"
        try {
            Stop-Transcript -ErrorAction SilentlyContinue
        }
        catch {
        }
        finally {
            Start-Transcript
        }

        Write-Verbose "Removing CliMenu Module"
        Remove-Module -Name "CliMenu" -Force -ErrorAction SilentlyContinue

        Write-Verbose "Setting Menu Options"
        Set-MenuOption -Heading "Shell Menu" -SubHeading "https://github.com/ronhowe" -MenuFillChar "#" -MenuFillColor Cyan
        Set-MenuOption -HeadingColor DarkCyan -MenuNameColor DarkGray -SubHeadingColor Green -FooterTextColor DarkGray
        Set-MenuOption -MaxWith 80

        ############################################################
        #region Common Menu Items

        $ExitMainMenuMenuItem = @{
            Name           = "ExitMainMenuMenuItem"
            DisplayName    = "Exit"
            Action         = { }
            DisableConfirm = $true
        }
        $ExitMainMenuMenuItem = New-MenuItem @ExitMainMenuMenuItem

        $GoToMainMenuMenuItem = @{
            Name           = "GoToMainMenuMenuItem"
            DisplayName    = "Main Menu"
            Action         = { Show-Menu }
            DisableConfirm = $true
        }
        $GoToMainMenuMenuItem = New-MenuItem @GoToMainMenuMenuItem

        #endregion Common Menu Items
        ############################################################

        ############################################################
        #region Main Menu

        # NOTE: DisplayName cannot exceed the MaxWidth value defined above by Set-MenuOption.

        #region Main Menu
        $MainMenu = @{
            Name        = "MainMenu"
            DisplayName = "Main Menu"
        }
        $MainMenu = New-Menu @MainMenu
        $ExitMainMenuMenuItem | Add-MenuItem -Menu "MainMenu"
        #endregion Main Menu

        #region Dependencies Menu
        $GoToDependenciesMenuMenuItem = @{
            Name           = "GoToDependenciesMenuMenuItem"
            DisplayName    = "Dependencies Menu"
            Action         = { Show-Menu -MenuName "DependenciesMenu" }
            DisableConfirm = $true
        }
        $GoToDependenciesMenuMenuItem = New-MenuItem @GoToDependenciesMenuMenuItem
        $GoToDependenciesMenuMenuItem | Add-MenuItem -Menu "MainMenu"
        #endregion Dependencies Menu

        #region Open Log Folder
        $OpenLogFolderMenuItem = @{
            Name           = "OpenLogFolderMenuItem"
            DisplayName    = "Open Log Folder"
            Action         = { explorer.exe "$HOME\repos\ronhowe\code\logs" ; Show-Menu -MenuName "MainMenu" }
            DisableConfirm = $true
        }
        $OpenLogFolderMenuItem = New-MenuItem @OpenLogFolderMenuItem
        $OpenLogFolderMenuItem | Add-MenuItem -Menu "MainMenu"
        #endregion Open Log Folder

        #endregion Main Menu
        ############################################################

        ############################################################
        #region Dependencies Menu

        #region Dependencies Menu
        $DependenciesMenu = @{
            Name        = "DependenciesMenu"
            DisplayName = "Dependencies Menu"
        }
        $DependenciesMenu = New-Menu @DependenciesMenu
        $GoToMainMenuMenuItem | Add-MenuItem -Menu "DependenciesMenu"
        #endregion Dependencies Menu

        #region Test Module Dependencies
        $TestModuleDependenciesMenuItem = @{
            Name           = "TestModuleDependenciesMenuItem"
            DisplayName    = "Test Module Dependencies"
            Action         = { & "$HOME\repos\ronhowe\code\powershell\dependencies\Test-Dependencies.ps1" ; Show-Menu -MenuName "DependenciesMenu" }
            DisableConfirm = $true
        }
        $TestModuleDependenciesMenuItem = New-MenuItem @TestModuleDependenciesMenuItem
        $TestModuleDependenciesMenuItem | Add-MenuItem -Menu "DependenciesMenu"
        #endregion Test Module Dependencies

        #endregion Dependencies Menu
        ############################################################

        Write-Verbose "Showing Menu"
        Show-Menu -Verbose:$false

        Write-Verbose "Stopping Transcript"
        Stop-Transcript

        Write-Verbose "Removing CliMenu Module"
        Remove-Module -Name "CliMenu" -Force -ErrorAction SilentlyContinue
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
