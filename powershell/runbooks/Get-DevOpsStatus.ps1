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

    $ErrorActionPreference = "Continue"

    Write-Verbose "Showing DevOps Tools"
    & "$HOME\repos\ronhowe\code\powershell\runbooks\Show-DevOpsTools.ps1" -Verbose

    Write-Verbose "Invoking Build Workflow"
    & "$HOME\repos\ronhowe\code\powershell\runbooks\Invoke-BuildWorkflow.ps1" -Verbose

    Write-Verbose "Running .NET List"
    dotnet list "$HOME\repos\ronhowe\code\dotnet\MySolution.sln" package --outdated

    Write-Verbose "Testing Dependencies"
    & "$HOME\repos\ronhowe\code\powershell\dependencies\Test-Dependencies.ps1"

    Write-Verbose "Debugging Module"
    & "$HOME\repos\ronhowe\code\powershell\module\Debug-Module.ps1"

    Write-Verbose "Running WinGet Upgrade"
    winget upgrade
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
