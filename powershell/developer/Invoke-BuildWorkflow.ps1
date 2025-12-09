[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]
    $Path = "$HOME\repos\ronhowe\dotnet"
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    $ErrorActionPreference = "Stop"

    try {
        Write-Verbose "Running .NET Clean"
        dotnet clean $Path
        if ($LASTEXITCODE -ne 0) {
            throw ".NET Clean Failed"
        }
    
        Write-Verbose "Running .NET Restore"
        dotnet restore $Path
        if ($LASTEXITCODE -ne 0) {
            throw ".NET Restore Failed"
        }

        Write-Verbose "Running .NET Build"
        dotnet build $Path --no-restore
        if ($LASTEXITCODE -ne 0) {
            throw ".NET Build Failed"
        }

        Write-Verbose "Running .NET Test"
        dotnet test $Path --no-build --nologo --filter "TestCategory=UnitTest" --verbosity normal
        if ($LASTEXITCODE -ne 0) {
            throw ".NET Test Failed"
        }
    }
    catch {
        Write-Error "Build Workflow Failed Because $($_.Message)"
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
