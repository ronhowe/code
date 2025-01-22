function Install-Dependencies {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateSet("AllUsers", "CurrentUser")]
        [string]
        $Scope = "CurrentUser"
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
                    Scope              = $Scope
                    SkipPublisherCheck = $true
                    Verbose            = $false
                    WarningAction      = "SilentlyContinue"
                }
                Install-Module @parameters
            }
        }
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
