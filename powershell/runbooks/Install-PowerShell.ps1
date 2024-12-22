#requires -Module BitsTransfer
#requires -PSEdition Desktop
#requires -RunAsAdministrator

[CmdletBinding()]
param(
    [string]
    $Source = "https://github.com/PowerShell/PowerShell/releases/download/v7.4.6/PowerShell-7.4.6-win-x64.msi"
)

$ErrorActionPreference = "Stop"

Write-Verbose "Downloading PowerShell Installer"
$destination = $(Join-Path -Path $env:TEMP -ChildPath "$(New-Guid).msi")
Write-Debug "destination = $destination"
Start-BitsTransfer -Source $Source -Destination $destination

Write-Verbose "Installing PowerShell"
$parameters = @{
    FilePath         = "msiexec.exe"
    ArgumentList     = @(
        "/package",
        $destination,
        "/quiet",
        "ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1",
        "ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1",
        "ENABLE_PSREMOTING=1",
        "REGISTER_MANIFEST=1",
        "USE_MU=1 ENABLE_MU=1",
        "ADD_PATH=1"
    )
    NoNewWindow      = $true
    Wait             = $true
    WorkingDirectory = $env:TEMP
}
Write-Debug "parameters = $($parameters | Out-String)"
Start-Process @parameters

Write-Verbose "Removing PowerShell Installer"
Remove-Item -Path $destination
