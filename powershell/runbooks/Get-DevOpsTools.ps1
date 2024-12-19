#requires -PSEdition "Core"

[CmdletBinding()]
param()

$ErrorActionPreference = "Continue"

Write-Verbose "Getting .NET (dotnet) Version"
dotnet --version

Write-Verbose "Getting Azure CLI (az) Version"
az --version

Write-Verbose "Getting Bicep (bicep) Version"
bicep --version

Write-Verbose "Getting Git CLI (git) Version"
git --version

Write-Verbose "Getting GitHub CLI (gh) Version"
gh --version

Write-Verbose "Getting NuGet (nuget) Version"
nuget | Select-String -SimpleMatch "NuGet Version"

Write-Verbose "Getting PowerShell (pwsh) Version"
pwsh --version

Write-Verbose "Getting Python (python) Version"
python --version

Write-Verbose "Getting Visual Studio Code (code) Version"
code --version

Write-Verbose "Getting Windows Subsystem For Linux (wsl) Version"
wsl --version
