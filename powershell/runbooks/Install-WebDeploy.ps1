[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Msi = "webdeploy_amd64_en-US.msi",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Source = "https://download.microsoft.com/download/b/d/8/bd882ec4-12e0-481a-9b32-0fae8e3c0b78/webdeploy_amd64_en-US.msi",

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
            $destination
        )
        NoNewWindow      = $true
        Wait             = $true
        WorkingDirectory = $env:TEMP
    }
    Write-Debug "`$parameters = $($parameters | Out-String)"
    Start-Process @parameters

    if ($Cleanup) {
        Write-Verbose "Removing Installer"
        Remove-Item -Path $destination
    }
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
