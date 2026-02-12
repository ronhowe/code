[CmdletBinding()]
param (
    [string]
    $Why = "Power-On Self-Test"
)
begin {
    Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
}
process {
    $ErrorActionPreference = "Stop"

    Write-Debug "Process $($MyInvocation.MyCommand.Name)"

    Write-Verbose "Power-On Self-Test (1 of 5) => `$DebugPreference = $DebugPreference"
    Write-Verbose "Power-On Self-Test (2 of 5) => `$VerbosePreference = $VerbosePreference"
    Write-Verbose "Power-On Self-Test (3 of 5) => `$InformationPreference = $InformationPreference"
    Write-Verbose "Power-On Self-Test (4 of 5) => `$WarningPreference = $WarningPreference"
    Write-Verbose "Power-On Self-Test (5 of 5) => `$ErrorActionPreference = $ErrorActionPreference"

    Write-Debug "Write-Debug Message"
    Write-Verbose "Write-Verbose Message"
    Write-Information "Write-Information Message"
    # does not output in Azure Automation
    Write-Host "Write-Host Message" -ForegroundColor Green

    Write-Verbose "Logging Who"
    @($env:USERNAME, $env:USER)

    Write-Verbose "Logging What"
    $PSVersionTable.PSVersion.ToString()

    Write-Verbose "Logging Where"
    @($env:COMPUTERNAME, $env:NAME)

    Write-Verbose "Logging When"
    (Get-Date).DateTime

    Write-Verbose "Logging Why"
    $Why
}
end {
    Write-Debug "End $($MyInvocation.MyCommand.Name)"
}
