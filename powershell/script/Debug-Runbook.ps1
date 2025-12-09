[CmdletBinding()]
param(
    [ValidateNotNullOrEmpty()]
    [string]
    $Why = "Debugging Runbook"
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Clear-Host

    Write-Host "POST"

    Write-Host "Writing Who (`$env:USERNAME)"
    Write-Host $env:USERNAME

    Write-Host "Writing What (`$PSVersionTable.PSEdition`)"
    Write-Host $PSVersionTable.PSEdition

    Write-Host "Writing What (`$PSVersionTable.PSVersion`)"
    Write-Host $PSVersionTable.PSVersion

    Write-Host "Writing Where (`$env:COMPUTERNAME`)"
    Write-Host $env:COMPUTERNAME

    Write-Host "Writing When"
    ## NOTE: PowerShell Core implements Get-Date -AsUTC.
    Write-Host "$([DateTime]::Now.ToString(`"yyyy-MM-dd HH:mm:ss.fff`")) (LOCAL)"
    Write-Host "$([DateTime]::UtcNow.ToString(`"yyyy-MM-dd HH:mm:ss.fff`")) (UTC)"

    Write-Host "Writing Why (`$Why`)"
    Write-Host $Why

    Write-Host "Writing How (`$MyInvocation.MyCommand.Name`)"
    Write-Host $MyInvocation.MyCommand.Name

    Write-Host "Writing How (`$PSCommandPath`)"
    Write-Host $PSCommandPath

    Write-Host "Writing How (`$PSScriptRoot`)"
    Write-Host $PSScriptRoot

    Write-Host "OK"
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
