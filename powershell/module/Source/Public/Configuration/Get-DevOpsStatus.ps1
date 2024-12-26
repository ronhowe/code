function Get-DevOpsStatus {
    [CmdletBinding()]
    param()

    Write-Verbose "Getting DevOps Tools"
    & "$HOME\repos\ronhowe\code\powershell\runbooks\Get-DevOpsTools.ps1" -Verbose

    Write-Verbose "Invoking Build Workflow"
    & "$HOME\repos\ronhowe\code\powershell\runbooks\Invoke-BuildWorkflow.ps1" -Verbose

    Write-Verbose "Running .NET List"
    dotnet list $HOME\repos\ronhowe\code\dotnet\MySolution.sln package --outdated

    Write-Verbose "Testing Dependencies"
    & "$HOME\repos\ronhowe\code\powershell\dependencies\Test-Dependencies.ps1"

    Write-Verbose "Debugging Module"
    & "$HOME\repos\ronhowe\code\powershell\module\Debug-Module.ps1"

    Write-Verbose "Running WinGet Upgrade"
    winget upgrade
}
