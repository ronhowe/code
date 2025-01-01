[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Msi = "dotnet-hosting-9.0.0-win.exe",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Source = "https://download.visualstudio.microsoft.com/download/pr/e1ae9d41-3faf-4755-ac27-b24e84eef3d1/5e3a24eb8c1a12272ea1fe126d17dfca/dotnet-hosting-9.0.0-win.exe",

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
            "/i",
            $destination,
            "/quiet",
            "/norestart"
        )
        NoNewWindow      = $true
        Wait             = $true
        WorkingDirectory = $env:TEMP
    }
    Write-Debug "`$parameters = $($parameters | Out-String)"
    Write-Warning "Downloaded ; Not Installed" -WarningAction Continue
    # Start-Process @parameters

    if ($Cleanup) {
        Write-Verbose "Removing Installer"
        Remove-Item -Path $destination
    }
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
