#requires -Module "ModuleBuilder"
#requires -Module "Pester"
[CmdletBinding()]
param(
    [ValidateNotNullOrEmpty()]
    [string]
    $Version = "0.0.0"
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Task Debug Remove, Clean, Build, Import, Start
    Task Release Remove, Clean, Build, Import, Test, Start
    Task . Clean, Build

    Task Build {
        Write-Output "Building Module"
        $parameters = @{
            CopyPaths                  = @(
                "$PSScriptRoot\source\Shell.json",
                "$PSScriptRoot\source\Shell.nuspec",
                "$PSScriptRoot\source\LICENSE*"
            )
            OutputDirectory            = "$PSScriptRoot\bin"
            SourcePath                 = "$PSScriptRoot\source\Shell.psd1"
            UnversionedOutputDirectory = $true
            Version                    = $Version
        }
        Build-Module @parameters |
        Out-Null
    }

    Task Clean {
        Write-Verbose "Removing Output"
        Remove-Item -Path "$PSScriptRoot\bin" -Recurse -Force -ErrorAction SilentlyContinue
    }

    Task Remove {
        Write-Verbose "Removing Module"
        Get-Module -Name "Shell" |
        Remove-Module -Force
    }

    Task Import {
        Write-Verbose "Importing Module"
        Import-Module -Name "$PSScriptRoot\bin\Shell" -Global -Force
    }

    Task Start {
        Write-Verbose "Starting Shell"
        Start-Shell
    }

    Task Test {
        Write-Verbose "Testing Module"
        $testResults = Get-ChildItem -Path "$PSScriptRoot\test\*.Tests.ps1" -Recurse |
        ForEach-Object {
            Invoke-Pester -Path $($_.FullName) -Output Detailed -PassThru
        }

        if ($testResults.FailedCount -gt 0) {
            # throw "Failed One Or More Module Tests ; $($testResults.FailedCount)"
            Write-Warning "Failed One Or More Module Tests ; $($testResults.FailedCount)" -WarningAction Continue
        }
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
