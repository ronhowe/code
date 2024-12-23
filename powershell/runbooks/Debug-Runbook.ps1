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

    Write-Verbose "Writing Who"
    Write-Output $env:USERNAME
    
    Write-Verbose "Writing What"
    Write-Output $PSVersionTable.PSEdition
    
    Write-Verbose "Writing Where"
    Write-Output $env:COMPUTERNAME
    
    Write-Verbose "Writing When"
    Write-Output (Get-Date -AsUTC).Date
    
    Write-Verbose "Writing Why"
    Write-Output $Why
    
    Write-Verbose "Writing How"
    Write-Output $MyInvocation.MyCommand.Name
    ## NOTE: PowerShell Core Only
    Write-Output $PSCommandPath
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
