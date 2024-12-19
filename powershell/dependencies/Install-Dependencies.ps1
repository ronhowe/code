[CmdletBinding()]
param ()

$ErrorActionPreference = "Stop"

Import-PowerShellDataFile -Path "$PSScriptRoot\Dependencies.psd1" |
Select-Object -ExpandProperty "Modules" |
ForEach-Object {
    if (Get-Module -FullyQualifiedName @{ ModuleName = $_.Name ; RequiredVersion = $_.Version } -ListAvailable -Verbose:$false) {
        Write-Verbose "Skipping Module Already Installed"
    }
    else {
        Write-Verbose "Installing Module @{ ModuleName = $($_.Name) ; RequiredVersion = $($_.Version) }"
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
