#requires -Module "ModuleBuilder"
[CmdletBinding()]
param(
    [ValidateNotNullOrEmpty()]
    [string]
    $Version = $((Get-Date).ToString("yyyy.MM.dd.hhmm"))
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

    Write-Verbose "Importing Configuration Module"
    Import-Module -Name "Configuration" -Verbose:$false 4>&1 |
    Out-Null

    Write-Verbose "Importing Metadata Module"
    Import-Module -Name "Metadata" -Verbose:$false 4>&1 |
    Out-Null

    Write-Verbose "Importing ModuleBuilder Module"
    Import-Module -Name "ModuleBuilder" -Verbose:$false 4>&1 |
    Out-Null

    Write-Verbose "Removing Output"
    Remove-Item -Path "$PSScriptRoot\bin" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Verbose "Building Module"
    $parameters = @{
        CopyPaths                  = @(
            "$PSScriptRoot\src\Shell.json",
            "$PSScriptRoot\src\Shell.nuspec",
            "$PSScriptRoot\..\dependencies\Dependencies.psd1",
            "$PSScriptRoot\..\dependencies\Dependencies.Tests.ps1",
            "$PSScriptRoot\..\dependencies\Install-Dependencies.ps1",
            "$PSScriptRoot\..\dependencies\Test-Dependencies.ps1",
            "$PSScriptRoot\LICENSE*"
            ## TODO: Add README.md to the list of files to copy.
            # "$PSScriptRoot\README.md"
        )
        OutputDirectory            = "$PSScriptRoot\bin"
        SourcePath                 = "$PSScriptRoot\src\Shell.psd1"
        UnversionedOutputDirectory = $true
        Verbose                    = $false
        Version                    = $Version
    }
    Build-Module @parameters 4>&1 |
    Out-Null
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
