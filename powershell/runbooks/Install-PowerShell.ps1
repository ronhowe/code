[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Msi = "PowerShell-7.4.6-win-x64.msi",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Source = "https://github.com/PowerShell/PowerShell/releases/download/v7.4.6/PowerShell-7.4.6-win-x64.msi",

    [switch]
    $Cleanup
)
begin {
    Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

    $ErrorActionPreference = "Stop"
    $ProgressPreference = "SilentlyContinue"

    Write-Verbose "Importing BitsTransfer Module"
    Import-Module -Name "BitsTransfer" -Verbose:$false 4>&1 |
    Out-Null

    Write-Verbose "Downloading Installer"
    $destination = "C:\installers\$Msi"
    Write-Debug "`$destination = $destination"
    Start-BitsTransfer -Source $Source -Destination $destination

    Write-Verbose "Starting Installer"
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
            "USE_MU=1",
            "ENABLE_MU=1",
            "ADD_PATH=1"
        )
        NoNewWindow      = $true
        Wait             = $true
        WorkingDirectory = $env:TEMP
    }
    Write-Debug "`$parameters = $($parameters | Out-String)"
    Start-Process @parameters

    Write-Verbose "Asserting Cleanup"
    if ($Cleanup) {
        Write-Verbose "Removing Installer"
        Remove-Item -Path $destination
    }
    else {
        Write-Verbose "Skipping Cleanup"
    }
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
