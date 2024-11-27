<###############################################################################
https://github.com/ronhowe
###############################################################################>

[CmdletBinding()]
param (
)

$ErrorActionPreference = "Stop"
Write-Output "Running $($MyInvocation.MyCommand.Name)"

Import-PowerShellDataFile -Path "$PSScriptRoot\Dependencies.psd1" |
Select-Object -ExpandProperty "Modules" |
ForEach-Object {
    Write-Output "Installing @{ ModuleName = $($_.Name) ; RequiredVersion = $($_.Version) }"

    if (Get-Module -FullyQualifiedName @{ ModuleName = $_.Name ; RequiredVersion = $_.Version } -ListAvailable -Verbose:$false) {
        Write-Output "Skipping Module Already Installed"
    }
    else {
        $parameters = @{
            AllowClobber       = $true
            ErrorAction        = "Stop"
            Force              = $true
            Name               = $_.Name
            Repository         = $_.Repository
            RequiredVersion    = $_.Version
            Scope              = $_.Scope
            SkipPublisherCheck = $true
            Verbose            = $false
            WarningAction      = "SilentlyContinue"
        }
        Install-Module @parameters
    }
}
