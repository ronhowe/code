<###############################################################################
https://github.com/ronhowe
###############################################################################>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = "$HOME\repos\ronhowe\code\dotnet"
)

$ErrorActionPreference = "Stop"
Write-Output "Running $($MyInvocation.MyCommand.Name)"

Measure-Command {
    try {
        Push-Location -Path $Path
        Write-Debug "Running dotnet clean"
        dotnet clean
        if ($LASTEXITCODE -ne 0) {
            throw "dotnet clean failed"
        }
        Write-Debug "dotnet restore"
        dotnet restore
        if ($LASTEXITCODE -ne 0) {
            throw "dotnet restore failed"
        }
        Write-Debug "dotnet build"
        dotnet build
        if ($LASTEXITCODE -ne 0) {
            throw "dotnet build failed"
        }
        Write-Debug "dotnet test"
        dotnet test
        if ($LASTEXITCODE -ne 0) {
            throw "dotnet test failed"
        }
    }
    catch {
        Write-Error $_
    }
    finally {
        Pop-Location
    }
}
