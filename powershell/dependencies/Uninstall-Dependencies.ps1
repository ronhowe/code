[CmdletBinding()]
param ()

$ErrorActionPreference = "Stop"

Import-PowerShellDataFile -Path "$PSScriptRoot\Dependencies.psd1" |
Select-Object -ExpandProperty "Modules" |
ForEach-Object {
    $moduleName = $_.Name
    $moduleVersion = $_.Version
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
