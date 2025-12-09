#requires -Module "InvokeBuild"
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

    Write-Verbose "Invoking Build"
    Invoke-Build -File "$PSScriptRoot\Build.ps1" -Task "Debug"
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
