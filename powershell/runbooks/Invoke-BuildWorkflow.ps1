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

    $ErrorActionPreference = "Stop"

    Write-Verbose "Pushing Location"
    Push-Location -Path "$HOME\repos\ronhowe\code"

    try {
        Write-Verbose "Running .NET Clean"
        dotnet clean ./dotnet
        if ($LASTEXITCODE -ne 0) {
            throw ".NET Clean Failed"
        }
    
        Write-Verbose "Running .NET Restore"
        dotnet restore ./dotnet
        if ($LASTEXITCODE -ne 0) {
            throw ".NET Restore Failed"
        }

        Write-Verbose "Running .NET Build"
        dotnet build ./dotnet --no-restore
        if ($LASTEXITCODE -ne 0) {
            throw ".NET Build Failed"
        }

        Write-Verbose "Running .NET Test"
        dotnet test ./dotnet --no-build --nologo --filter "TestCategory=UnitTest" --verbosity normal
        if ($LASTEXITCODE -ne 0) {
            throw ".NET Test Failed"
        }
    }
    catch {
        Write-Error "Build Workflow Failed Because $($_.Message)"
    }
    finally {
        Write-Verbose "Popping Location"
        Pop-Location
    }
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
