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

    Write-Verbose "Rebuilding Module"
    & "$PSScriptRoot\Rebuild-Module.ps1" -Verbose -Debug

    Write-Verbose "Importing Module"
    Import-Module -Name "$PSScriptRoot\bin\Shell" -Global -Force -Verbose -Debug

    Write-Verbose "Testing Module"
    & "$PSScriptRoot\Test-Module.ps1" -Verbose -Debug
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
