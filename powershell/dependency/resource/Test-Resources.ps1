#requires -Module "Pester"
#requires -PSEdition "Desktop"
#requires -RunAsAdministrator
[CmdletBinding()]
param(
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Output "Invoking Pester"
    Invoke-Pester -Path "$PSScriptRoot\Resources.Tests.ps1" -Output Detailed
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
