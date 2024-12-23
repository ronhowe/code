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

    Write-Verbose "Getting .NET (dotnet) Version"
    dotnet --version

    Write-Verbose "Getting Azure CLI (az) Version"
    az --version

    Write-Verbose "Getting Bicep CLI (bicep) Version"
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
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
