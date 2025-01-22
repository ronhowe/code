function Uninstall-Dependencies {
    [CmdletBinding()]
    param(
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
            $moduleName = $_.Name
            $moduleVersion = $_.Version
            Write-Verbose "Getting Installed Modules @{ ModuleName = $moduleName }"
            Get-InstalledModule -Name $moduleName -AllVersions -Verbose:$false |
            Where-Object { $_.Version -ne $moduleVersion } |
            Sort-Object -Property "Version" |
            ForEach-Object {
                if ($_.Name -ne "Pester" -and $_.Name -ne "PSReadLine") {
                    Write-Verbose "Uninstalling Module @{ ModuleName = $($_.Name) ; RequiredVersion = $($_.Version) }"
                    Uninstall-Module -Name $_.Name -RequiredVersion $_.Version -Verbose:$false
                }
                else {
                    ## TODO: Understand why Pester and PSReadLine are tricky to uninstall.
                    Write-Warning "Skipping Module @{ ModuleName = $($_.Name) ; RequiredVersion = $($_.Version) }"
                }
            }
        }
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
