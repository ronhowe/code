#requires -PSEdition "Desktop"
#requires -RunAsAdministrator
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]
    $Path = "$PSScriptRoot\Resources.psd1"
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    (Import-PowerShellDataFile -Path $Path).Resources |
    ForEach-Object {
        $moduleName = $_.Name
        $moduleVersion = $_.Version
        Write-Output "Getting Installed Versions Of Resource @{ ModuleName = $moduleName }"
        Get-InstalledModule -Name $moduleName -AllVersions |
        Where-Object { $_.Version -ne $moduleVersion } |
        Sort-Object -Property "Version" |
        ForEach-Object {
            if ($_.Name -ne "Pester" -and $_.Name -ne "PSReadLine") {
                Write-Output "Uninstalling Resource @{ ModuleName = $($_.Name) ; RequiredVersion = $($_.Version) }"
                Uninstall-Module -Name $_.Name -RequiredVersion $_.Version
            }
            else {
                Write-Warning "Skipping Resource @{ ModuleName = $($_.Name) ; RequiredVersion = $($_.Version) }"
            }
        }
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
