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

    Write-Verbose "Measuring Build Workflow"
    Measure-Command {
        & "$HOME\repos\ronhowe\code\powershell\runbooks\Invoke-BuildWorkflow.ps1"
    }
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
