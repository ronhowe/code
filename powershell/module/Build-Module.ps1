#requires -Module "ModuleBuilder"
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

    Write-Verbose "Removing Output"
    Remove-Item -Path "$PSScriptRoot\Output" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Verbose "Building Module"
    $parameters = @{
        CopyPaths                  = @(
            "$PSScriptRoot\Source\Shell.json",
            "$PSScriptRoot\Source\Shell.nuspec",
            "$PSScriptRoot\..\dependencies\Dependencies.psd1",
            "$PSScriptRoot\..\dependencies\Dependencies.Tests.ps1",
            "$PSScriptRoot\..\dependencies\Install-Dependencies.ps1",
            "$PSScriptRoot\..\dependencies\Test-Dependencies.ps1",
            "$PSScriptRoot\LICENSE*"
            # "$PSScriptRoot\README.md"
        )
        OutputDirectory            = "$PSScriptRoot\Output"
        SourcePath                 = "$PSScriptRoot\Source\Shell.psd1"
        UnversionedOutputDirectory = $true
        Verbose                    = $false
        Version                    = "0.0.0"
    }
    Build-Module @parameters
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
