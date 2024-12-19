[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Verbose "Measuring Build Workflow"
Measure-Command {
    & "$HOME\repos\ronhowe\code\powershell\runbooks\Invoke-BuildWorkflow.ps1"
}
