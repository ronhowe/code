[CmdletBinding()]
param (
)

$ErrorActionPreference = "Stop"
Write-Debug "Running $($MyInvocation.MyCommand.Name)"

Import-PowerShellDataFile -Path "$PSScriptRoot\Dependencies.psd1" |
Select-Object -ExpandProperty "Modules" |
ForEach-Object {
    $moduleName = $_.Name
    $moduleVersion = $_.Version
    Get-InstalledModule -Name $moduleName -AllVersions |
    Where-Object { $_.Version -ne $moduleVersion } |
    Sort-Object -Property "Version" |
    ForEach-Object {
        if ($_.Name -ne "Pester" -and $_.Name -ne "PSReadLine") {
            Write-Output "Uninstalling @{ ModuleName = $($_.Name) ; RequiredVersion = $($_.Version) }"
            Uninstall-Module -Name $_.Name -RequiredVersion $_.Version
        }
        else {
            Write-Warning "Skipping @{ ModuleName = $($_.Name) ; RequiredVersion = $($_.Version) }"
        }
    }
}
