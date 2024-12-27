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
    $(dotnet --version) |
    Out-String |
    Write-Verbose -Verbose

    Write-Verbose "Getting Azure CLI (az) Version"
    $(az --version) |
    Out-String |
    Write-Verbose -Verbose

    Write-Verbose "Getting Bicep CLI (bicep) Version"
    $(bicep --version) |
    Out-String |
    Write-Verbose -Verbose

    Write-Verbose "Getting Git CLI (git) Version"
    $(git --version) |
    Out-String |
    Write-Verbose -Verbose

    Write-Verbose "Getting GitHub CLI (gh) Version"
    $(gh --version) |
    Out-String |
    Write-Verbose -Verbose

    Write-Verbose "Getting NuGet (nuget) Version"
    $(nuget | Select-String -SimpleMatch "NuGet Version") |
    Out-String |
    Write-Verbose -Verbose

    Write-Verbose "Getting PowerShell (pwsh) Version"
    $(pwsh --version) |
    Out-String |
    Write-Verbose -Verbose

    Write-Verbose "Getting Python (python) Version"
    $(python --version) |
    Out-String |
    Write-Verbose -Verbose

    Write-Verbose "Getting Visual Studio Code (code) Version"
    $(code --version) |
    Out-String |
    Write-Verbose -Verbose

    Write-Verbose "Getting Windows Subsystem For Linux (wsl) Version"
    $(wsl --version) |
    Out-String |
    Write-Verbose -Verbose
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
