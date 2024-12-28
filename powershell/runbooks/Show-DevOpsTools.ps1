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
    if (Get-Command -Name "dotnet" -ErrorAction SilentlyContinue) {
        $(dotnet --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning ".NET (dotnet) Not Found"
    }

    if (Get-Command -Name "az" -ErrorAction SilentlyContinue) {
        Write-Verbose "Getting Azure CLI (az) Version"
        $(az --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "Azure CLI (az) Not Found"
    }

    if (Get-Command -Name "bicep" -ErrorAction SilentlyContinue) {
        Write-Verbose "Getting Bicep CLI (bicep) Version"
        $(bicep --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "Bicep CLI (bicep) Not Found"
    }

    if (Get-Command -Name "git" -ErrorAction SilentlyContinue) {
        Write-Verbose "Getting Git CLI (git) Version"
        $(git --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "Git CLI (git) Not Found"
    }

    if (Get-Command -Name "gh" -ErrorAction SilentlyContinue) {
        Write-Verbose "Getting GitHub CLI (gh) Version"
        $(gh --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "GitHub CLI (gh) Not Found"
    }

    if (Get-Command -Name "nuget" -ErrorAction SilentlyContinue) {
        Write-Verbose "Getting NuGet (nuget) Version"
        $(nuget | Select-String -SimpleMatch "NuGet Version") |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "NuGet (nuget) Not Found"
    }

    if (Get-Command -Name "pwsh" -ErrorAction SilentlyContinue) {
        Write-Verbose "Getting PowerShell (pwsh) Version"
        $(pwsh --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "PowerShell (pwsh) Not Found"
    }

    if (Get-Command -Name "python" -ErrorAction SilentlyContinue) {
        Write-Verbose "Getting Python (python) Version"
        $(python --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "Python (python) Not Found"
    }

    if (Get-Command -Name "code" -ErrorAction SilentlyContinue) {
        Write-Verbose "Getting Visual Studio Code (code) Version"
        $(code --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "Visual Studio Code (code) Not Found"
    }

    if (Get-Command -Name "wsl" -ErrorAction SilentlyContinue) {
        Write-Verbose "Getting Windows Subsystem For Linux (wsl) Version"
        $(wsl --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "Windows Subsystem For Linux (wsl) Not Found"
    }
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
