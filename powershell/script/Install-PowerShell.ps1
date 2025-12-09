#requires -PSEdition "Desktop"
#requires -RunAsAdministrator
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Uri = "https://github.com/PowerShell/PowerShell/releases/download/v7.5.4/PowerShell-7.5.4-win-x64.msi",

    [switch]
    $Cleanup
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    $ProgressPreference = "SilentlyContinue"

    $fileName = [System.IO.Path]::GetFileName($Uri)
    Write-Debug "`$fileName = $fileName"

    Write-Host "Importing BitsTransfer Module"
    Import-Module -Name "BitsTransfer" |
    Out-Null

    Write-Host "Starting Bits Transfer"
    $destination = "$env:TEMP\$fileName"
    Write-Debug "`$destination = $destination"

    try {
        Start-BitsTransfer -Source $Uri -Destination $destination -ErrorAction Stop
    }
    catch {
        throw "Failed To Transfer Bits Bits Transfer From $Uri ; $_"
    }

    if (-not (Test-Path -Path $destination)) {
        throw "Failed To Find Installer At $destination"
    }

    Write-Host "Starting Installer"
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
        PassThru         = $true
        Wait             = $true
        WorkingDirectory = $env:TEMP
    }
    Write-Debug "`$parameters = $($parameters | Out-String)"
    $process = Start-Process @parameters

    if ($process.ExitCode -ne 0) {
        throw "Failed To Install With Exit Code $($process.ExitCode)"
    }

    Write-Host "Asserting Cleanup"
    if ($Cleanup) {
        Write-Host "Removing Installer"
        Remove-Item -Path $destination
    }
    else {
        Write-Host "Skipping Cleanup"
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
