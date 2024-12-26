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

    Write-Verbose "Cleaning Module"
    & "$PSScriptRoot\Clean-Module.ps1"

    Write-Verbose "Building Module"
    & "$PSScriptRoot\Build-Module.ps1"
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
