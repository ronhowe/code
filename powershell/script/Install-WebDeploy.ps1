[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Msi = "webdeploy_amd64_en-US.msi",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Source = "https://download.microsoft.com/download/webdeploy_amd64_en-US.msi",

    [switch]
    $Cleanup
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    $ErrorActionPreference = "Stop"
    $ProgressPreference = "SilentlyContinue"

    Write-Host "Importing BitsTransfer Module"
    Import-Module -Name "BitsTransfer" |
    Out-Null

    Write-Host "Starting Bits Transfer"
    $destination = "C:\installers\$Msi"
    Write-Debug "`$destination = $destination"

    try {
        Start-BitsTransfer -Source $Source -Destination $destination -ErrorAction Stop
    }
    catch {
        throw "Failed To Transfer Bits Bits Transfer From $Source ; $_"
    }

    if (-not (Test-Path -Path $destination)) {
        throw "Failed To Find Installer At $destination"
    }

    Write-Host "Starting Installer"
    $parameters = @{
        FilePath         = "msiexec.exe"
        ArgumentList     = @(
            "/i",
            $destination,
            "/quiet",
            "/norestart"
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
