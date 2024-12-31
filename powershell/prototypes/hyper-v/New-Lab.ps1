[CmdletBinding()]
param(
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Nodes
)
begin {
    Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

    Write-Verbose "Invoking Host Configuration"
    & "$PSScriptRoot\Invoke-HostConfiguration.ps1" -Nodes $Nodes -Ensure "Present" -Wait
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
