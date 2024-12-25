function Start-Menu {
    begin {
        Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
    }
    process {
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
        Set-MenuOption -Heading "IDIBilling PowerShell Menu" -SubHeading "Billing Is Not Boring!" -MenuFillChar "#" -MenuFillColor Cyan
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

        # #region Installers Menu"
        # $GoToInstallersMenuMenuItem = @{
        #     Name           = "GoToInstallersMenuMenuItem"
        #     DisplayName    = "Installers Menu"
        #     Action         = { Show-Menu -MenuName "InstallersMenu" }
        #     DisableConfirm = $true
        # }
        # $GoToInstallersMenuMenuItem = New-MenuItem @GoToInstallersMenuMenuItem
        # $GoToInstallersMenuMenuItem | Add-MenuItem -Menu "MainMenu"
        # #endregion Installers Menu"

        # #region Infrastructure Tests Menu
        # $GoToInfrastructureTestsMenuMenuItem = @{
        #     Name           = "GoToInfrastructureTestsMenuMenuItem"
        #     DisplayName    = "Infrastructure Tests Menu"
        #     Action         = { Show-Menu -MenuName "InfrastructureTestsMenu" }
        #     DisableConfirm = $true
        # }
        # $GoToInfrastructureTestsMenuMenuItem = New-MenuItem @GoToInfrastructureTestsMenuMenuItem
        # $GoToInfrastructureTestsMenuMenuItem | Add-MenuItem -Menu "MainMenu"
        # #endregion Infrastructure Tests Menu

        # #region Patch Maintenance Menu
        # $GoToPatchMaintenanceMenuMenuItem = @{
        #     Name           = "GoToPatchMaintenanceMenuMenuItem"
        #     DisplayName    = "Patch Maintenance Menu"
        #     Action         = { Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $true
        # }
        # $GoToPatchMaintenanceMenuMenuItem = New-MenuItem @GoToPatchMaintenanceMenuMenuItem
        # $GoToPatchMaintenanceMenuMenuItem | Add-MenuItem -Menu "MainMenu"
        # #endregion Patch Maintenance Menu

        # #region USPS Maintenance Menu
        # $GoToUspsMaintenanceMenuMenuItem = @{
        #     Name           = "GoToUspsMaintenanceMenuMenuItem"
        #     DisplayName    = "USPS Maintenance Menu"
        #     Action         = { Show-Menu -MenuName "UspsMaintenanceMenu" }
        #     DisableConfirm = $true
        # }
        # $GoToUspsMaintenanceMenuMenuItem = New-MenuItem @GoToUspsMaintenanceMenuMenuItem
        # $GoToUspsMaintenanceMenuMenuItem | Add-MenuItem -Menu "MainMenu"
        # #endregion USPS Maintenance Menu

        # #region DSC Maintenance Menu
        # $GoToDscMaintenanceMenuMenuItem = @{
        #     Name           = "GoToDscMaintenanceMenuMenuItem"
        #     DisplayName    = "DSC Maintenance Menu"
        #     Action         = { Show-Menu -MenuName "DscMaintenanceMenu" }
        #     DisableConfirm = $true
        # }
        # $GoToDscMaintenanceMenuMenuItem = New-MenuItem @GoToDscMaintenanceMenuMenuItem
        # $GoToDscMaintenanceMenuMenuItem | Add-MenuItem -Menu "MainMenu"
        # #endregion DSC Maintenance Menu

        # #region vCenter Menu
        # $GoTovCenterMenuMenuItem = @{
        #     Name           = "GoTovCenterMenuMenuItem"
        #     DisplayName    = "vCenter Menu"
        #     Action         = { Show-Menu -MenuName "vCenterMenu" }
        #     DisableConfirm = $true
        # }
        # $GoTovCenterMenuMenuItem = New-MenuItem @GoTovCenterMenuMenuItem
        # $GoTovCenterMenuMenuItem | Add-MenuItem -Menu "MainMenu"
        # #endregion vCenter Menu

        #region Open Log Folder
        $OpenLogFolderMenuItem = @{
            Name           = "OpenLogFolderMenuItem"
            DisplayName    = "Open Log Folder"
            Action         = { explorer.exe $HOME ; Show-Menu -MenuName "MainMenu" }
            DisableConfirm = $true
        }
        $OpenLogFolderMenuItem = New-MenuItem @OpenLogFolderMenuItem
        $OpenLogFolderMenuItem | Add-MenuItem -Menu "MainMenu"
        #endregion Open Log Folder

        #endregion Main Menu
        ############################################################

        # ############################################################
        # #region Installers Menu

        # #region Installers Menu
        # $InstallersMenu = @{
        #     Name        = "InstallersMenu"
        #     DisplayName = "Installers Menu"
        # }
        # $InstallersMenu = New-Menu @InstallersMenu
        # $GoToMainMenuMenuItem | Add-MenuItem -Menu "InstallersMenu"
        # #endregion Installers Menu

        # #region Install IDI Module Requirements
        # $InvokeInstalDIModuleRequirementsMenuItem = @{
        #     Name           = "InvokeInstalDIModuleRequirementsMenuItem"
        #     DisplayName    = "Install IDI Module Requirements"
        #     Action         = { & "$PSScriptRoot\Install-Requirements.ps1" ; Show-Menu -MenuName "InstallersMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeInstalDIModuleRequirementsMenuItem = New-MenuItem @InvokeInstalDIModuleRequirementsMenuItem
        # $InvokeInstalDIModuleRequirementsMenuItem | Add-MenuItem -Menu "InstallersMenu"
        # #endregion Install IDI Module Requirements

        # #endregion Installers Menu
        # ############################################################

        # ############################################################
        # #region Infrastructure Tests Menu

        # #region Infrastructure Tests Menu
        # $InfrastructureTestsMenu = @{
        #     Name        = "InfrastructureTestsMenu"
        #     DisplayName = "Infrastructure Tests Menu"
        # }
        # $InfrastructureTestsMenu = New-Menu @InfrastructureTestsMenu
        # $GoToMainMenuMenuItem | Add-MenuItem -Menu "InfrastructureTestsMenu"
        # #endregion Infrastructure Tests Menu

        # #region Credential Tests
        # $InvokeInfrastructureCredentialTestsMenuItem = @{
        #     Name           = "InvokeInfrastructureCredentialTestsMenuItem"
        #     DisplayName    = "Credential Tests"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Tests\CredentialTests.ps1" ; Show-Menu -MenuName "InfrastructureTestsMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeInfrastructureCredentialTestsMenuItem = New-MenuItem @InvokeInfrastructureCredentialTestsMenuItem
        # $InvokeInfrastructureCredentialTestsMenuItem | Add-MenuItem -Menu "InfrastructureTestsMenu"
        # #endregion Credential Tests

        # #region Infrastructure Smoke Tests (Global)
        # $InvokeInfrastructureSmokeTestsMenuItem = @{
        #     Name           = "InvokeInfrastructureSmokeTestsMenuItem"
        #     DisplayName    = "Infrastructure Smoke Tests (Global)"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Tests\InvokeInfrastructureSmokeTests.ps1" ; Show-Menu -MenuName "InfrastructureTestsMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeInfrastructureSmokeTestsMenuItem = New-MenuItem @InvokeInfrastructureSmokeTestsMenuItem
        # $InvokeInfrastructureSmokeTestsMenuItem | Add-MenuItem -Menu "InfrastructureTestsMenu"
        # #endregion Infrastructure Smoke Tests (Global)

        # #region Infrastructure Smoke Tests AZIE1 (Mitel Europe)
        # $InvokeInfrastructureSmokeTestsAZIE1MenuItem = @{
        #     Name           = "InvokeInfrastructureSmokeTestAZIE1MenuItem"
        #     DisplayName    = "Infrastructure Smoke Tests AZIE1 (Mitel Europe)"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Tests\InvokeInfrastructureSmokeTestsAZIE1.ps1" ; Show-Menu -MenuName "InfrastructureTestsMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeInfrastructureSmokeTestsAZIE1MenuItem = New-MenuItem @InvokeInfrastructureSmokeTestsAZIE1MenuItem
        # $InvokeInfrastructureSmokeTestsAZIE1MenuItem | Add-MenuItem -Menu "InfrastructureTestsMenu"
        # #endregion Infrastructure Smoke Tests AZIE1 (Mitel Europe)

        # #region Infrastructure Smoke Tests OPGU1 (IT&E)
        # $InvokeInfrastructureSmokeTestsOPGU1MenuItem = @{
        #     Name           = "InvokeInfrastructureSmokeTestOPGU1sMenuItem"
        #     DisplayName    = "Infrastructure Smoke Tests OPGU1 (IT&E)"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Tests\InvokeInfrastructureSmokeTestsOPGU1.ps1" ; Show-Menu -MenuName "InfrastructureTestsMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeInfrastructureSmokeTestsOPGU1MenuItem = New-MenuItem @InvokeInfrastructureSmokeTestsOPGU1MenuItem
        # $InvokeInfrastructureSmokeTestsOPGU1MenuItem | Add-MenuItem -Menu "InfrastructureTestsMenu"
        # #endregion Infrastructure Smoke Tests OPGU1 (IT&E)

        # #region Infrastructure Smoke Tests OPUS1 (FCC)
        # $InvokeInfrastructureSmokeTestsOPUS1MenuItem = @{
        #     Name           = "InvokeInfrastructureSmokeTestOPUS1MenuItem"
        #     DisplayName    = "Infrastructure Smoke Tests OPUS1 (FCC)"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Tests\InvokeInfrastructureSmokeTestsOPUS1.ps1" ; Show-Menu -MenuName "InfrastructureTestsMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeInfrastructureSmokeTestsOPUS1MenuItem = New-MenuItem @InvokeInfrastructureSmokeTestsOPUS1MenuItem
        # $InvokeInfrastructureSmokeTestsOPUS1MenuItem | Add-MenuItem -Menu "InfrastructureTestsMenu"
        # #endregion Infrastructure Smoke Tests OPUS1 (FCC)

        # #region Infrastructure Smoke Tests OPUS3 (Appalachian)
        # $InvokeInfrastructureSmokeTestsOPUS3MenuItem = @{
        #     Name           = "InvokeInfrastructureSmokeTestOPUS3MenuItem"
        #     DisplayName    = "Infrastructure Smoke Tests OPUS3 (Appalachian)"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Tests\InvokeInfrastructureSmokeTestsOPUS3.ps1" ; Show-Menu -MenuName "InfrastructureTestsMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeInfrastructureSmokeTestsOPUS3MenuItem = New-MenuItem @InvokeInfrastructureSmokeTestsOPUS3MenuItem
        # $InvokeInfrastructureSmokeTestsOPUS3MenuItem | Add-MenuItem -Menu "InfrastructureTestsMenu"
        # #endregion Infrastructure Smoke Tests OPUS3 (Appalachian)

        # #region Infrastructure Maintenance Tests
        # $InvokeInfrastructureMaintenanceTestsMenuItem = @{
        #     Name           = "InvokeInfrastructureMaintenanceTestsMenuItem"
        #     DisplayName    = "Infrastructure Maintenance Tests"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Tests\InvokeInfrastructureMaintenanceTests.ps1" ; Show-Menu -MenuName "InfrastructureTestsMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeInfrastructureMaintenanceTestsMenuItem = New-MenuItem @InvokeInfrastructureMaintenanceTestsMenuItem
        # $InvokeInfrastructureMaintenanceTestsMenuItem | Add-MenuItem -Menu "InfrastructureTestsMenu"
        # #endregion Infrastructure Maintenance Tests

        # #region Infrastructure WinRM Tests Custom
        # $InvokeInfrastructureWinRmTestsCustomMenuItem = @{
        #     Name           = "InvokeInfrastructureWinRmTestsCustomMenuItem"
        #     DisplayName    = "Infrastructure WinRM Tests Custom"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Tests\InvokeInfrastructureWinRmTestsCustom.ps1" ; Show-Menu -MenuName "InfrastructureTestsMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeInfrastructureWinRmTestsCustomMenuItem = New-MenuItem @InvokeInfrastructureWinRmTestsCustomMenuItem
        # $InvokeInfrastructureWinRmTestsCustomMenuItem | Add-MenuItem -Menu "InfrastructureTestsMenu"
        # #endregion Infrastructure WinRM Tests Custom

        # #endregion Infrastructure Tests Menu
        # ############################################################

        # ############################################################
        # #region Patch Maintenance Menu

        # #region Patch Maintenance Menu
        # $PatchMaintenanceMenu = @{
        #     Name        = "PatchMaintenanceMenu"
        #     DisplayName = "Patch Maintenance Menu"
        # }
        # $PatchMaintenanceMenu = New-Menu @PatchMaintenanceMenu
        # $GoToMainMenuMenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Patch Maintenance Menu

        # #region Export CSV Reboot Summary AZIE1 (Mitel Europe)
        # $InvokeExportCsvRebootSummaryAZIE1MenuItem = @{
        #     Name           = "InvokeExportCsvRebootSummaryAZIE1MenuItem"
        #     DisplayName    = "Export CSV Reboot Summary AZIE1 (Mitel Europe)"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\ExportCsvRebootSummaryAZIE1.ps1" ; Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeExportCsvRebootSummaryAZIE1MenuItem = New-MenuItem @InvokeExportCsvRebootSummaryAZIE1MenuItem
        # $InvokeExportCsvRebootSummaryAZIE1MenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Export CSV Reboot Summary AZIE1 (Mitel Europe)

        # #region Export CSV Reboot Summary OPGU1 (IT&E)
        # $InvokeExportCsvRebootSummaryOPGU1MenuItem = @{
        #     Name           = "InvokeExportCsvRebootSummaryOPGU1MenuItem"
        #     DisplayName    = "Export CSV Reboot Summary OPGU1 (IT&E)"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\ExportCsvRebootSummaryOPGU1.ps1" ; Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeExportCsvRebootSummaryOPGU1MenuItem = New-MenuItem @InvokeExportCsvRebootSummaryOPGU1MenuItem
        # $InvokeExportCsvRebootSummaryOPGU1MenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Export CSV Reboot Summary OPGU1 (IT&E)

        # #region Export CSV Reboot Summary OPUS3 (Appalachian)
        # $InvokeExportCsvRebootSummaryOPUS3MenuItem = @{
        #     Name           = "InvokeExportCsvRebootSummaryOPUS3MenuItem"
        #     DisplayName    = "Export CSV Reboot Summary OPUS3 (Appalachian)"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\ExportCsvRebootSummaryOPUS3.ps1" ; Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeExportCsvRebootSummaryOPUS3MenuItem = New-MenuItem @InvokeExportCsvRebootSummaryOPUS3MenuItem
        # $InvokeExportCsvRebootSummaryOPUS3MenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Export CSV Reboot Summary OPUS3 (Appalachian)

        # #region Export CSV Reboot Summary Production Patch Group
        # $InvokeExportCsvRebootSummaryProductionPatchGroupMenuItem = @{
        #     Name           = "InvokeExportCsvRebootSummaryProductionPatchGroupMenuItem"
        #     DisplayName    = "Export CSV Reboot Summary Production Patch Group"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\ExportCsvRebootSummaryProductionPatchGroup.ps1" ; Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeExportCsvRebootSummaryProductionPatchGroupMenuItem = New-MenuItem @InvokeExportCsvRebootSummaryProductionPatchGroupMenuItem
        # $InvokeExportCsvRebootSummaryProductionPatchGroupMenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Export CSV Reboot Summary Production Patch Group

        # #region Export CSV Reboot Summary Stage Patch Group
        # $InvokeExportCsvRebootSummaryStagePatchGroupMenuItem = @{
        #     Name           = "InvokeExportCsvRebootSummaryStagePatchGroupMenuItem"
        #     DisplayName    = "Export CSV Reboot Summary Stage Patch Group"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\ExportCsvRebootSummaryStagePatchGroup.ps1" ; Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeExportCsvRebootSummaryStagePatchGroupMenuItem = New-MenuItem @InvokeExportCsvRebootSummaryStagePatchGroupMenuItem
        # $InvokeExportCsvRebootSummaryStagePatchGroupMenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Export CSV Reboot Summary Stage Patch Group

        # #region Export CSV Reboot Summary Operations Patch Group
        # $InvokeExportCsvRebootSummaryOperationsPatchGroupMenuItem = @{
        #     Name           = "InvokeExportCsvRebootSummaryOperationsPatchGroupMenuItem"
        #     DisplayName    = "Export CSV Reboot Summary Operations Patch Group"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\ExportCsvRebootSummaryOperationsPatchGroup.ps1" ; Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeExportCsvRebootSummaryOperationsPatchGroupMenuItem = New-MenuItem @InvokeExportCsvRebootSummaryOperationsPatchGroupMenuItem
        # $InvokeExportCsvRebootSummaryOperationsPatchGroupMenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Export CSV Reboot Summary Operations Patch Group

        # #region Export CSV Reboot Summary Manual Patch Group
        # $InvokeExportCsvRebootSummaryManualPatchGroupMenuItem = @{
        #     Name           = "InvokeExportCsvRebootSummaryManualPatchGroupMenuItem"
        #     DisplayName    = "Export CSV Reboot Summary Manual Patch Group"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\ExportCsvRebootSummaryManualPatchGroup.ps1" ; Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeExportCsvRebootSummaryManualPatchGroupMenuItem = New-MenuItem @InvokeExportCsvRebootSummaryManualPatchGroupMenuItem
        # $InvokeExportCsvRebootSummaryManualPatchGroupMenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Export CSV Reboot Summary Manual Patch Group

        # #region Export CSV Reboot Summary Engineering Patch Group
        # $InvokeExportCsvRebootSummaryEngineeringPatchGroupMenuItem = @{
        #     Name           = "InvokeExportCsvRebootSummaryEngineeringPatchGroupMenuItem"
        #     DisplayName    = "Export CSV Reboot Summary Engineering Patch Group"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\ExportCsvRebootSummaryEngineeringPatchGroup.ps1" ; Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeExportCsvRebootSummaryEngineeringPatchGroupMenuItem = New-MenuItem @InvokeExportCsvRebootSummaryEngineeringPatchGroupMenuItem
        # $InvokeExportCsvRebootSummaryEngineeringPatchGroupMenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Export CSV Reboot Summary Engineering Patch Group

        # #region Get Farm Distributed Frame Workers (Global)
        # $InvokeGetFarmDistributedFrameworkWorkersAllMenuItem = @{
        #     Name           = "InvokeGetFarmDistributedFrameworkWorkersAllMenuItem"
        #     DisplayName    = "Get Farm Distributed Frame Workers (Global)"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\GetFarmDistributedFrameworkWorkersAll.ps1" ; Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeGetFarmDistributedFrameworkWorkersAllMenuItem = New-MenuItem @InvokeGetFarmDistributedFrameworkWorkersAllMenuItem
        # $InvokeGetFarmDistributedFrameworkWorkersAllMenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Get Farm Distributed Frame Workers (Global)

        # #region Pause Farm Distributed Framework Workers AZIE1 (Mitel Europe)
        # $InvokePauseFarmDistributedFrameworkWorkersAZIE1MenuItem = @{
        #     Name           = "InvokePauseFarmDistributedFrameworkWorkersAZIE1MenuItem"
        #     DisplayName    = "Pause Farm Distributed Framework Workers AZIE1 (Mitel Europe)"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\PauseFarmDistributedFrameworkWorkersAZIE1.ps1" ; Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $false
        # }
        # $InvokePauseFarmDistributedFrameworkWorkersAZIE1MenuItem = New-MenuItem @InvokePauseFarmDistributedFrameworkWorkersAZIE1MenuItem
        # $InvokePauseFarmDistributedFrameworkWorkersAZIE1MenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Pause Farm Distributed Framework Workers AZIE1 (Mitel Europe)

        # #region Pause Farm Distributed Framework Workers OPGU1 (IT&E)
        # $InvokePauseFarmDistributedFrameworkWorkersOPGU1MenuItem = @{
        #     Name           = "InvokePauseFarmDistributedFrameworkWorkersOPGU1MenuItem"
        #     DisplayName    = "Pause Farm Distributed Framework Workers OPGU1 (IT&E)"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\PauseFarmDistributedFrameworkWorkersOPGU1.ps1" ; Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $false
        # }
        # $InvokePauseFarmDistributedFrameworkWorkersOPGU1MenuItem = New-MenuItem @InvokePauseFarmDistributedFrameworkWorkersOPGU1MenuItem
        # $InvokePauseFarmDistributedFrameworkWorkersOPGU1MenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Pause Farm Distributed Framework Workers OPGU1 (IT&E)

        # #region Pause Farm Distributed Framework Workers OPUS1 (FCC)
        # $InvokePauseFarmDistributedFrameworkWorkersOPUS1MenuItem = @{
        #     Name           = "InvokePauseFarmDistributedFrameworkWorkersOPUS1MenuItem"
        #     DisplayName    = "Pause Farm Distributed Framework Workers OPUS1 (FCC)"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\PauseFarmDistributedFrameworkWorkersOPUS1.ps1" ; Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $false
        # }
        # $InvokePauseFarmDistributedFrameworkWorkersOPUS1MenuItem = New-MenuItem @InvokePauseFarmDistributedFrameworkWorkersOPUS1MenuItem
        # $InvokePauseFarmDistributedFrameworkWorkersOPUS1MenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Pause Farm Distributed Framework Workers OPUS1 (FCC)

        # #region Pause Farm Distributed Framework Workers OPUS3 (Appalachian)
        # $InvokePauseFarmDistributedFrameworkWorkersOPUS3MenuItem = @{
        #     Name           = "InvokePauseFarmDistributedFrameworkWorkersOPUS3MenuItem"
        #     DisplayName    = "Pause Farm Distributed Framework Workers OPUS3 (Appalachian)"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\PauseFarmDistributedFrameworkWorkersOPUS3.ps1" ; Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $false
        # }
        # $InvokePauseFarmDistributedFrameworkWorkersOPUS3MenuItem = New-MenuItem @InvokePauseFarmDistributedFrameworkWorkersOPUS3MenuItem
        # $InvokePauseFarmDistributedFrameworkWorkersOPUS3MenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Pause Farm Distributed Framework Workers OPUS3 (Appalachian)

        # #region Resume Farm Distributed Framework Workers AZIE1 (Mitel Europe)
        # $InvokeResumeFarmDistributedFrameworkWorkersAZIE1MenuItem = @{
        #     Name           = "InvokeResumeFarmDistributedFrameworkWorkersAZIE1MenuItem"
        #     DisplayName    = "Resume Farm Distributed Framework Workers AZIE1 (Mitel Europe)"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\ResumeFarmDistributedFrameworkWorkersAZIE1.ps1" ; Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $false
        # }
        # $InvokeResumeFarmDistributedFrameworkWorkersAZIE1MenuItem = New-MenuItem @InvokeResumeFarmDistributedFrameworkWorkersAZIE1MenuItem
        # $InvokeResumeFarmDistributedFrameworkWorkersAZIE1MenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Resume Farm Distributed Framework Workers AZIE1 (Mitel Europe)

        # #region Resume Farm Distributed Framework Workers OPGU1 (IT&E)
        # $InvokeResumeFarmDistributedFrameworkWorkersOPGU1MenuItem = @{
        #     Name           = "InvokeResumeFarmDistributedFrameworkWorkersOPGU1MenuItem"
        #     DisplayName    = "Resume Farm Distributed Framework Workers OPGU1 (IT&E)"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\ResumeFarmDistributedFrameworkWorkersOPGU1.ps1" ; Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $false
        # }
        # $InvokeResumeFarmDistributedFrameworkWorkersOPGU1MenuItem = New-MenuItem @InvokeResumeFarmDistributedFrameworkWorkersOPGU1MenuItem
        # $InvokeResumeFarmDistributedFrameworkWorkersOPGU1MenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Resume Farm Distributed Framework Workers OPGU1 (IT&E)

        # #region Resume Farm Distributed Framework Workers OPUS1 (FCC)
        # $InvokeResumeFarmDistributedFrameworkWorkersOPUS1MenuItem = @{
        #     Name           = "InvokeResumeFarmDistributedFrameworkWorkersOPUS1MenuItem"
        #     DisplayName    = "Resume Farm Distributed Framework Workers OPUS1 (FCC)"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\ResumeFarmDistributedFrameworkWorkersOPUS1.ps1" ; Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $false
        # }
        # $InvokeResumeFarmDistributedFrameworkWorkersOPUS1MenuItem = New-MenuItem @InvokeResumeFarmDistributedFrameworkWorkersOPUS1MenuItem
        # $InvokeResumeFarmDistributedFrameworkWorkersOPUS1MenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Resume Farm Distributed Framework Workers OPUS1 (FCC)

        # #region Resume Farm Distributed Framework Workers OPUS3 (Appalachian)
        # $InvokeResumeFarmDistributedFrameworkWorkersOPUS3MenuItem = @{
        #     Name           = "InvokeResumeFarmDistributedFrameworkWorkersOPUS3MenuItem"
        #     DisplayName    = "Resume Farm Distributed Framework Workers OPUS3 (Appalachian)"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\ResumeFarmDistributedFrameworkWorkersOPUS3.ps1" ; Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $false
        # }
        # $InvokeResumeFarmDistributedFrameworkWorkersOPUS3MenuItem = New-MenuItem @InvokeResumeFarmDistributedFrameworkWorkersOPUS3MenuItem
        # $InvokeResumeFarmDistributedFrameworkWorkersOPUS3MenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Resume Farm Distributed Framework Workers OPUS3 (Appalachian)

        # #region Reboot Farm AZIE1 (Mitel Europe)
        # $InvokeRebootFarmAZIE1MenuItem = @{
        #     Name           = "InvokeRebootFarmAZIE1MenuItem"
        #     DisplayName    = "Reboot Farm AZIE1 (Mitel Europe)"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\RebootFarmAZIE1.ps1" ; Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $false
        # }
        # $InvokeRebootFarmAZIE1MenuItem = New-MenuItem @InvokeRebootFarmAZIE1MenuItem
        # $InvokeRebootFarmAZIE1MenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Reboot Farm AZIE1 (Mitel Europe)

        # #region Reboot Farm OPGU1 (IT&E)
        # $InvokeRebootFarmOPGU1MenuItem = @{
        #     Name           = "InvokeRebootFarmOPGU1MenuItem"
        #     DisplayName    = "Reboot Farm OPGU1 (IT&E)"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\RebootFarmOPGU1.ps1" ; Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $false
        # }
        # $InvokeRebootFarmOPGU1MenuItem = New-MenuItem @InvokeRebootFarmOPGU1MenuItem
        # $InvokeRebootFarmOPGU1MenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Reboot Farm OPGU1 (IT&E)

        # #region Reboot Farm OPUS1 (FCC)
        # $InvokeRebootFarmOPUS1MenuItem = @{
        #     Name           = "InvokeRebootFarmOPUS1MenuItem"
        #     DisplayName    = "Reboot Farm OPUS1 (FCC)"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\RebootFarmOPUS1.ps1" ; Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $false
        # }
        # $InvokeRebootFarmOPUS1MenuItem = New-MenuItem @InvokeRebootFarmOPUS1MenuItem
        # $InvokeRebootFarmOPUS1MenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Reboot Farm OPUS1 (FCC)

        # #region Reboot Farm OPUS3 (Appalachian)
        # $InvokeRebootFarmOPUS3MenuItem = @{
        #     Name           = "InvokeRebootFarmOPUS3MenuItem"
        #     DisplayName    = "Reboot Farm OPUS3 (Appalachian)"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\RebootFarmOPUS3.ps1" ; Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $false
        # }
        # $InvokeRebootFarmOPUS3MenuItem = New-MenuItem @InvokeRebootFarmOPUS3MenuItem
        # $InvokeRebootFarmOPUS3MenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Reboot Farm OPUS3 (Appalachian)

        # #region Reboot Servers OPGU1 (IT&E) Stage
        # $InvokeRebootServersOPGU1StageMenuItem = @{
        #     Name           = "InvokeRebootServersOPGU1StageMenuItem"
        #     DisplayName    = "Reboot Servers OPGU1 (IT&E) Stage"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\RebootServersOPGU1Stage.ps1" ; Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $false
        # }
        # $InvokeRebootServersOPGU1StageMenuItem = New-MenuItem @InvokeRebootServersOPGU1StageMenuItem
        # $InvokeRebootServersOPGU1StageMenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Reboot Servers OPGU1 (IT&E) Stage

        # #region Reboot Servers Custom
        # $InvokeRebootServersCustomMenuItem = @{
        #     Name           = "InvokeRebootServersCustomMenuItem"
        #     DisplayName    = "Reboot Servers Custom"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\RebootServersCustom.ps1" -Verbose ; Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $false
        # }
        # $InvokeRebootServersCustomMenuItem = New-MenuItem @InvokeRebootServersCustomMenuItem
        # $InvokeRebootServersCustomMenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Reboot Servers Custom

        # #region Start Customer Application Server IDI Services Production
        # $InvokeStartCustomerApplicationServerIDIServicesProductionMenuItem = @{
        #     Name           = "InvokeStartCustomerApplicationServerIDIServicesProductionMenuItem"
        #     DisplayName    = "Start Customer Application Server IDI Services Production"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\StartCustomerApplicationServerIDIServicesProduction.ps1" ; Show-Menu -MenuName "PatchMaintenanceMenu" }
        #     DisableConfirm = $false
        # }
        # $InvokeStartCustomerApplicationServerIDIServicesProductionMenuItem = New-MenuItem @InvokeStartCustomerApplicationServerIDIServicesProductionMenuItem
        # $InvokeStartCustomerApplicationServerIDIServicesProductionMenuItem | Add-MenuItem -Menu "PatchMaintenanceMenu"
        # #endregion Start Customer Application Server IDI Services Production

        # #endregion Patch Maintenance Menu
        # ############################################################

        # ############################################################
        # #region USPS Maintenance Menu

        # #region USPS Maintenance Menu
        # $UspsMaintenanceMenu = @{
        #     Name        = "UspsMaintenanceMenu"
        #     DisplayName = "USPS Maintenance Menu"
        # }
        # $UspsMaintenanceMenu = New-Menu @UspsMaintenanceMenu
        # $GoToMainMenuMenuItem | Add-MenuItem -Menu "UspsMaintenanceMenu"
        # #endregion USPS Maintenance Menu

        # #region Export CSV Customer Application Server USPS Version Production
        # $InvokeExportCsvCustomerApplicationServerUspsVersionProductionMenuItem = @{
        #     Name           = "InvokeExportCsvCustomerApplicationServerUspsVersionProductionMenuItem"
        #     DisplayName    = "Export CSV Customer Application Server USPS Version Production"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\ExportCsvCustomerApplicationServerUspsVersionProduction.ps1" ; Show-Menu -MenuName "UspsMaintenanceMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeExportCsvCustomerApplicationServerUspsVersionProductionMenuItem = New-MenuItem @InvokeExportCsvCustomerApplicationServerUspsVersionProductionMenuItem
        # $InvokeExportCsvCustomerApplicationServerUspsVersionProductionMenuItem | Add-MenuItem -Menu "UspsMaintenanceMenu"
        # #endregion Export CSV Customer Application Server USPS Version Production

        # #region Export CSV Customer Application Server USPS Version Stage
        # $InvokeExportCsvCustomerApplicationServerUspsVersionStageMenuItem = @{
        #     Name           = "InvokeExportCsvCustomerApplicationServerUspsVersionStageMenuItem"
        #     DisplayName    = "Export CSV Customer Application Server USPS Version Stage"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\ExportCsvCustomerApplicationServerUspsVersionStage.ps1" ; Show-Menu -MenuName "UspsMaintenanceMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeExportCsvCustomerApplicationServerUspsVersionStageMenuItem = New-MenuItem @InvokeExportCsvCustomerApplicationServerUspsVersionStageMenuItem
        # $InvokeExportCsvCustomerApplicationServerUspsVersionStageMenuItem | Add-MenuItem -Menu "UspsMaintenanceMenu"
        # #endregion Export CSV Customer Application Server USPS Version Stage

        # #region Deploy Customer Application Server USPS OPGU1 (IT&E) Production
        # $InvokeDeployCustomerApplicationServerUspsOPGU1ProductionMenuItem = @{
        #     Name           = "InvokeDeployCustomerApplicationServerUspsOPGU1ProductionMenuItem"
        #     DisplayName    = "Deploy Customer Application Server USPS OPGU1 (IT&E) Production"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\DeployCustomerApplicationServerUspsOPGU1Production.ps1" -ErrorAction Continue ; Show-Menu -MenuName "UspsMaintenanceMenu" }
        #     DisableConfirm = $false
        # }
        # $InvokeDeployCustomerApplicationServerUspsOPGU1ProductionMenuItem = New-MenuItem @InvokeDeployCustomerApplicationServerUspsOPGU1ProductionMenuItem
        # $InvokeDeployCustomerApplicationServerUspsOPGU1ProductionMenuItem | Add-MenuItem -Menu "UspsMaintenanceMenu"
        # #endregion Deploy Customer Application Server USPS OPGU1 (IT&E) Production

        # #region Deploy Customer Application Server USPS OPGU1 (IT&E) Stage
        # $InvokeDeployCustomerApplicationServerUspsOPGU1StageMenuItem = @{
        #     Name           = "InvokeDeployCustomerApplicationServerUspsOPGU1StageMenuItem"
        #     DisplayName    = "Deploy Customer Application Server USPS OPGU1 (IT&E) Stage"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\DeployCustomerApplicationServerUspsOPGU1Stage.ps1" -ErrorAction Continue ; Show-Menu -MenuName "UspsMaintenanceMenu" }
        #     DisableConfirm = $false
        # }
        # $InvokeDeployCustomerApplicationServerUspsOPGU1StageMenuItem = New-MenuItem @InvokeDeployCustomerApplicationServerUspsOPGU1StageMenuItem
        # $InvokeDeployCustomerApplicationServerUspsOPGU1StageMenuItem | Add-MenuItem -Menu "UspsMaintenanceMenu"
        # #endregion Deploy Customer Application Server USPS OPGU1 (IT&E) Stage

        # #region Deploy Customer Application Server USPS OPUS1 (FCC) Production
        # $InvokeDeployCustomerApplicationServerUspsOPUS1ProductionMenuItem = @{
        #     Name           = "InvokeDeployCustomerApplicationServerUspsOPUS1ProductionMenuItem"
        #     DisplayName    = "Deploy Customer Application Server USPS OPUS1 (FCC) Production"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\DeployCustomerApplicationServerUspsOPUS1Production.ps1" -ErrorAction Continue ; Show-Menu -MenuName "UspsMaintenanceMenu" }
        #     DisableConfirm = $false
        # }
        # $InvokeDeployCustomerApplicationServerUspsOPUS1ProductionMenuItem = New-MenuItem @InvokeDeployCustomerApplicationServerUspsOPUS1ProductionMenuItem
        # $InvokeDeployCustomerApplicationServerUspsOPUS1ProductionMenuItem | Add-MenuItem -Menu "UspsMaintenanceMenu"
        # #endregion Deploy Customer Application Server USPS OPUS1 (FCC) Production

        # #region Deploy Customer Application Server USPS OPUS1 (FCC) Stage
        # $InvokeDeployCustomerApplicationServerUspsOPUS1StageMenuItem = @{
        #     Name           = "InvokeDeployCustomerApplicationServerUspsOPUS1StageMenuItem"
        #     DisplayName    = "Deploy Customer Application Server USPS OPUS1 (FCC) Stage"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\DeployCustomerApplicationServerUspsOPUS1Stage.ps1" -ErrorAction Continue ; Show-Menu -MenuName "UspsMaintenanceMenu" }
        #     DisableConfirm = $false
        # }
        # $InvokeDeployCustomerApplicationServerUspsOPUS1StageMenuItem = New-MenuItem @InvokeDeployCustomerApplicationServerUspsOPUS1StageMenuItem
        # $InvokeDeployCustomerApplicationServerUspsOPUS1StageMenuItem | Add-MenuItem -Menu "UspsMaintenanceMenu"
        # #endregion Deploy Customer Application Server USPS OPUS1 (FCC) Stage

        # #region Deploy Customer Application Server USPS OPUS3 (Appalachian) Production
        # $InvokeDeployCustomerApplicationServerUspsOPUS3ProductionMenuItem = @{
        #     Name           = "InvokeDeployCustomerApplicationServerUspsOPUS3ProductionMenuItem"
        #     DisplayName    = "Deploy Customer Application Server USPS OPUS3 (Appalachian) Production"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\DeployCustomerApplicationServerUspsOPUS3Production.ps1" -ErrorAction Continue ; Show-Menu -MenuName "UspsMaintenanceMenu" }
        #     DisableConfirm = $false
        # }
        # $InvokeDeployCustomerApplicationServerUspsOPUS3ProductionMenuItem = New-MenuItem @InvokeDeployCustomerApplicationServerUspsOPUS3ProductionMenuItem
        # $InvokeDeployCustomerApplicationServerUspsOPUS3ProductionMenuItem | Add-MenuItem -Menu "UspsMaintenanceMenu"
        # #endregion Deploy Customer Application Server USPS OPUS3 (Appalachian) Production

        # #region Deploy Customer Application Server USPS OPUS3 (Appalachian) Stage
        # $InvokeDeployCustomerApplicationServerUspsOPUS3StageMenuItem = @{
        #     Name           = "InvokeDeployCustomerApplicationServerUspsOPUS3StageMenuItem"
        #     DisplayName    = "Deploy Customer Application Server USPS OPUS3 (Appalachian) Stage"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Maintenance\DeployCustomerApplicationServerUspsOPUS3Stage.ps1" -ErrorAction Continue ; Show-Menu -MenuName "UspsMaintenanceMenu" }
        #     DisableConfirm = $false
        # }
        # $InvokeDeployCustomerApplicationServerUspsOPUS3StageMenuItem = New-MenuItem @InvokeDeployCustomerApplicationServerUspsOPUS3StageMenuItem
        # $InvokeDeployCustomerApplicationServerUspsOPUS3StageMenuItem | Add-MenuItem -Menu "UspsMaintenanceMenu"
        # #endregion Deploy Customer Application Server USPS OPUS3 (Appalachian) Stage

        # #endregion USPS Maintenance Menu
        # ############################################################

        # ############################################################
        # #region DSC Maintenance Menu

        # #region DSC Maintenance Menu
        # $DscMaintenanceMenu = @{
        #     Name        = "DscMaintenanceMenu"
        #     DisplayName = "DSC Maintenance Menu"
        # }
        # $DscMaintenanceMenu = New-Menu @DscMaintenanceMenu
        # $GoToMainMenuMenuItem | Add-MenuItem -Menu "DscMaintenanceMenu"
        # #endregion DSC Maintenance Menu

        # #region Deploy DSC to Engineering Patch Group
        # $InvokeDeployDscToEngineeringPatchGroupMenuItem = @{
        #     Name           = "InvokeDeployDscToEngineeringPatchGroupMenuItem"
        #     DisplayName    = "Deploy DSC to Engineering Patch Group"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Dsc\DeployDsc.ps1" -PatchGroup "Engineering"; Show-Menu -MenuName "DscMaintenanceMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeDeployDscToEngineeringPatchGroupMenuItem = New-MenuItem @InvokeDeployDscToEngineeringPatchGroupMenuItem
        # $InvokeDeployDscToEngineeringPatchGroupMenuItem | Add-MenuItem -Menu "DSCMaintenanceMenu"
        # #endregion Deploy DSC to Engineering Patch Group

        # #region Deploy DSC to Operations Patch Group
        # $InvokeDeployDscToOperationsPatchGroupMenuItem = @{
        #     Name           = "InvokeDeployDscToOperationsPatchGroupMenuItem"
        #     DisplayName    = "Deploy DSC to Operations Patch Group"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Dsc\DeployDsc.ps1" -PatchGroup "Operations"; Show-Menu -MenuName "DscMaintenanceMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeDeployDscToOperationsPatchGroupMenuItem = New-MenuItem @InvokeDeployDscToOperationsPatchGroupMenuItem
        # $InvokeDeployDscToOperationsPatchGroupMenuItem | Add-MenuItem -Menu "DscMaintenanceMenu"
        # #endregion Deploy DSC to Operations Patch Group

        # #region Deploy DSC to Manual Patch Group
        # $InvokeDeployDscToManualPatchGroupMenuItem = @{
        #     Name           = "InvokeDeployDscToManualPatchGroupMenuItem"
        #     DisplayName    = "Deploy DSC to Manual Patch Group"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Dsc\DeployDsc.ps1" -PatchGroup "Manual"; Show-Menu -MenuName "DscMaintenanceMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeDeployDscToManualPatchGroupMenuItem = New-MenuItem @InvokeDeployDscToManualPatchGroupMenuItem
        # $InvokeDeployDscToManualPatchGroupMenuItem | Add-MenuItem -Menu "DscMaintenanceMenu"
        # #endregion Deploy DSC to Manual Patch Group

        # #region Deploy DSC to Stage Group 1 (FCC, Appalachian) Patch Group
        # $InvokeDeployDscToStageGroup1PatchGroupMenuItem = @{
        #     Name           = "InvokeDeployDscToStageGroup1PatchGroupMenuItem"
        #     DisplayName    = "Deploy DSC to Stage Group 1 (FCC, Appalachian) Patch Group"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Dsc\DeployDsc.ps1" -PatchGroup "StageGroup1"; Show-Menu -MenuName "DscMaintenanceMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeDeployDscToStageGroup1PatchGroupMenuItem = New-MenuItem @InvokeDeployDscToStageGroup1PatchGroupMenuItem
        # $InvokeDeployDscToStageGroup1PatchGroupMenuItem | Add-MenuItem -Menu "DscMaintenanceMenu"
        # #endregion Deploy DSC to Stage Group 1 (FCC, Appalachian) Patch Group

        # #region Deploy DSC to Stage Group 2 (IT&E) Patch Group
        # $InvokeDeployDscToStageGroup2PatchGroupMenuItem = @{
        #     Name           = "InvokeDeployDscToStageGroup2PatchGroupMenuItem"
        #     DisplayName    = "Deploy DSC to Stage Group 2 (IT&E) Patch Group"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Dsc\DeployDsc.ps1" -PatchGroup "StageGroup2"; Show-Menu -MenuName "DscMaintenanceMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeDeployDscToStageGroup2PatchGroupMenuItem = New-MenuItem @InvokeDeployDscToStageGroup2PatchGroupMenuItem
        # $InvokeDeployDscToStageGroup2PatchGroupMenuItem | Add-MenuItem -Menu "DscMaintenanceMenu"
        # #endregion Deploy DSC to Stage Group 2 (IT&E) Patch Group

        # #region Deploy DSC to Production Group 2 (IT&E) Patch Group
        # $InvokeDeployDscToProductionGroup2PatchGroupMenuItem = @{
        #     Name           = "InvokeDeployDscToProductionGroup2PatchGroupMenuItem"
        #     DisplayName    = "Deploy DSC to Production Group 2 (IT&E) Patch Group"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Dsc\DeployDsc.ps1" -PatchGroup "ProductionGroup2"; Show-Menu -MenuName "DscMaintenanceMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeDeployDscToProductionGroup2PatchGroupMenuItem = New-MenuItem @InvokeDeployDscToProductionGroup2PatchGroupMenuItem
        # $InvokeDeployDscToProductionGroup2PatchGroupMenuItem | Add-MenuItem -Menu "DscMaintenanceMenu"
        # #endregion Deploy DSC to Production Group 2 (IT&E) Patch Group

        # #region Deploy DSC to Production Group 1 (FCC, Appalachian) Patch Group
        # $InvokeDeployDscToProductionGroup1PatchGroupMenuItem = @{
        #     Name           = "InvokeDeployDscToProductionGroup1PatchGroupMenuItem"
        #     DisplayName    = "Deploy DSC to Production Group 1 (FCC, Appalachian) Patch Group"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Dsc\DeployDsc.ps1" -PatchGroup "ProductionGroup1"; Show-Menu -MenuName "DscMaintenanceMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeDeployDscToProductionGroup1PatchGroupMenuItem = New-MenuItem @InvokeDeployDscToProductionGroup1PatchGroupMenuItem
        # $InvokeDeployDscToProductionGroup1PatchGroupMenuItem | Add-MenuItem -Menu "DscMaintenanceMenu"
        # #endregion Deploy DSC to Production Group 1 (FCC, Appalachian) Patch Group

        # #region Deploy DSC Domain Servers
        # $InvokeDeployDscDomainServersMenuItem = @{
        #     Name           = "InvokeDeployDscDomainServersMenuItem"
        #     DisplayName    = "Deploy DSC to Domain Servers"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Dsc\DeployDscDomainServers.ps1"; Show-Menu -MenuName "DscMaintenanceMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeDeployDscDomainServersMenuItem = New-MenuItem @InvokeDeployDscDomainServersMenuItem
        # $InvokeDeployDscDomainServersMenuItem | Add-MenuItem -Menu "DscMaintenanceMenu"
        # #endregion Deploy DSC Domain Servers

        # #region Deploy DSC Custom
        # $InvokeDeployDscCustomMenuItem = @{
        #     Name           = "InvokeDeployDscCustomMenuItem"
        #     DisplayName    = "Deploy DSC to Custom Server List"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Dsc\DeployDscCustom.ps1"; Show-Menu -MenuName "DscMaintenanceMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeDeployDscCustomMenuItem = New-MenuItem @InvokeDeployDscCustomMenuItem
        # $InvokeDeployDscCustomMenuItem | Add-MenuItem -Menu "DscMaintenanceMenu"
        # #endregion Deploy DSC Custom

        # #region Boostrap DSC Node
        # $InvokeBootstrapDscNodeMenuItem = @{
        #     Name           = "InvokeBootstrapDscNodeMenuItem"
        #     DisplayName    = "Boostrap DSC Node"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\Dsc\BootstrapDscNode.ps1"; Show-Menu -MenuName "DscMaintenanceMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeBootstrapDscNodeMenuItem = New-MenuItem @InvokeBootstrapDscNodeMenuItem
        # $InvokeBootstrapDscNodeMenuItem | Add-MenuItem -Menu "DscMaintenanceMenu"
        # #endregion Boostrap DSC Node

        # #endregion DSC Maintenance Menu
        # ############################################################

        # ############################################################
        # #region vCenter Menu

        # #region vCenter Menu
        # $vCenterMenu = @{
        #     Name        = "vCenterMenu"
        #     DisplayName = "vCenter Menu"
        # }
        # $vCenterMenu = New-Menu @vCenterMenu
        # $GoToMainMenuMenuItem | Add-MenuItem -Menu "vCenterMenu"
        # #endregion

        # #region Export CSV Virtual Machine Summary
        # $InvokeExportCsvVirtualMachineSummaryMenuItem = @{
        #     Name           = "InvokeExportCsvVirtualMachineSummaryMenuItem"
        #     DisplayName    = "Export CSV Virtual Machine Summary"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\vCenter\ExportCsvVirtualMachineSummary.ps1" ; Show-Menu -MenuName "vCenterMenu" }
        #     DisableConfirm = $true
        # }
        # $InvokeExportCsvVirtualMachineSummaryMenuItem = New-MenuItem @InvokeExportCsvVirtualMachineSummaryMenuItem
        # $InvokeExportCsvVirtualMachineSummaryMenuItem | Add-MenuItem -Menu "vCenterMenu"
        # #endregion Export CSV Virtual Machine Summary

        # #region New Virtual Machine Snapshot Custom
        # $InvokeNewVirtualMachineSnapshotCustomMenuItem = @{
        #     Name           = "InvokeNewVirtualMachineSnapshotCustomMenuItem"
        #     DisplayName    = "New Virtual Machine Snapshot Custom"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\vCenter\NewVirtualMachineSnapshotCustom.ps1" ; Show-Menu -MenuName "vCenterMenu" }
        #     DisableConfirm = $false
        # }
        # $InvokeNewVirtualMachineSnapshotCustomMenuItem = New-MenuItem @InvokeNewVirtualMachineSnapshotCustomMenuItem
        # $InvokeNewVirtualMachineSnapshotCustomMenuItem | Add-MenuItem -Menu "vCenterMenu"
        # #endregion New Virtual Machine Snapshot Custom

        # #region Remove Virtual Machine Snapshot Custom
        # $InvokeRemoveVirtualMachineSnapshotCustomMenuItem = @{
        #     Name           = "InvokeRemoveVirtualMachineSnapshotCustomMenuItem"
        #     DisplayName    = "Remove Virtual Machine Snapshot Custom"
        #     Action         = { Get-Date | Write-Verbose -Verbose ; & "$env:ProgramFiles\WindowsPowerShell\Modules\IDI.Operations\$IDIOperationsModuleVersion\Scripts\vCenter\RemoveVirtualMachineSnapshotCustom.ps1" ; Show-Menu -MenuName "vCenterMenu" }
        #     DisableConfirm = $false
        # }
        # $InvokeRemoveVirtualMachineSnapshotCustomMenuItem = New-MenuItem @InvokeRemoveVirtualMachineSnapshotCustomMenuItem
        # $InvokeRemoveVirtualMachineSnapshotCustomMenuItem | Add-MenuItem -Menu "vCenterMenu"
        # #endregion Remove Virtual Machine Snapshot Custom

        # #endregion vCenter Menu
        # ############################################################

        Write-Verbose "Showing Menu"
        Show-Menu -Verbose:$false

        Write-Verbose "Stopping Transcript"
        Stop-Transcript

        Write-Verbose "Removing CliMenu Module"
        Remove-Module -Name "CliMenu" -Force -ErrorAction SilentlyContinue
    }
    end {
        Write-Debug "End $($MyInvocation.MyCommand.Name)"
    }
}
