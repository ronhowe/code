<###############################################################################
https://github.com/ronhowe
###############################################################################>

$ErrorActionPreference = "Stop"
Write-Output "Running $($MyInvocation.MyCommand.Name)"

Write-Output "Pushing Location"
Push-Location -Path "$HOME\repos\ronhowe\code"

try {
    Write-Output "Running .NET Clean"
    dotnet clean ./dotnet
    if ($LASTEXITCODE -ne 0) {
        throw ".NET Clean Failed"
    }
    Write-Output "Running .NET Restore"
    dotnet restore ./dotnet
    if ($LASTEXITCODE -ne 0) {
        throw ".NET Restore Failed"
    }
    Write-Output "Running .NET Build"
    dotnet build ./dotnet --no-restore
    if ($LASTEXITCODE -ne 0) {
        throw ".NET Build Failed"
    }
    Write-Output "Running .NET Test"
    dotnet test ./dotnet --no-build --nologo --filter "TestCategory=UnitTest" --verbosity normal
    if ($LASTEXITCODE -ne 0) {
        throw ".NET Test Failed"
    }
}
catch {
    Write-Error "Build Workflow Failed Because $($_.Message)"
}
finally {
    Write-Output "Popping Location"
    Pop-Location
}
