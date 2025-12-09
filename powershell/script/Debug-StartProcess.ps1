#requires -PSEdition "Core"
function Debug-StartProcess {
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        $parameters = @{
            FilePath     = "pwsh.exe"
            ArgumentList = @("--version")
            NoNewWindow  = $true
            PassThru     = $true
            Wait         = $true
        }
        $process = Start-Process @parameters

        $parameters = @{
            FilePath     = "pwsh.exe"
            ArgumentList = @("--notarealparameter")
            NoNewWindow  = $true
            PassThru     = $true
            Wait         = $true
        }
        $process = Start-Process @parameters
        if ($process.ExitCode -ne 0) {
            Write-Error "Failed To Start Process ; Exit Code $($process.ExitCode)"
        }

        try {
            $parameters = @{
                FilePath     = "hswp.exe"
                ArgumentList = @("--version")
                NoNewWindow  = $true
                PassThru     = $true
                Wait         = $true
            }
            $process = Start-Process @parameters
            if ($process.ExitCode -ne 0) {
                Write-Error "Failed To Start Process ; Exit Code $($process.ExitCode)"
            }
        }
        catch {
            throw $_
        }

        Write-Host "Done"
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
Clear-Host
Wait-Debugger
Debug-StartProcess
