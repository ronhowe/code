<###############################################################################
https://github.com/ronhowe
###############################################################################>

$ErrorActionPreference = "Stop"
Write-Output "Running $($MyInvocation.MyCommand.Name)"

Write-Output "Measuring Build Workflow"
Measure-Command {
    & "$HOME\repos\ronhowe\code\powershell\prototypes\dotnet\Invoke-BuildWorkflow.ps1"
}
