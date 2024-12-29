[CmdletBinding()]
param(
    [ValidateNotNullOrEmpty()]
    [string]
    $Why = "Debugging"
)
begin {
    Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

    Write-Host "Writing Who (`$env:USERNAME)"
    Write-Host $env:USERNAME

    Write-Host "Writing What (`$PSVersionTable.PSEdition`)"
    Write-Host $PSVersionTable.PSEdition

    Write-Host "Writing What (`$PSVersionTable.PSVersion`)"
    Write-Host $PSVersionTable.PSVersion

    Write-Host "Writing Where (`$env:COMPUTERNAME`)"
    Write-Output $env:COMPUTERNAME

    Write-Host "Writing When"
    Write-Host (Get-Date -AsUTC).Date

    Write-Host "Writing Why (`$Why`)"
    Write-Host $Why

    Write-Host "Writing How (`$MyInvocation.MyCommand.Name`)"
    Write-Host $MyInvocation.MyCommand.Name

    Write-Host "Writing How (`$PSCommandPath`)"
    Write-Host $PSCommandPath

    Write-Host "Writing How (`$PSScriptRoot`)"
    Write-Host $PSScriptRoot
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
