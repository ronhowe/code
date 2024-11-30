#requires -RunAsAdministrator
#requires -Module BitsTransfer

[CmdletBinding()]
param(
    [string]$Source = "https://github.com/PowerShell/PowerShell/releases/download/v7.3.4/PowerShell-7.3.4-win-x64.msi"
)

$ErrorActionPreference = "Stop"

$destination = $(Join-Path -Path $env:TEMP -ChildPath "$(New-Guid).msi")

Start-BitsTransfer -Source $Source -Destination $destination

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
Start-Process @parameters

Remove-Item -Path $destination
