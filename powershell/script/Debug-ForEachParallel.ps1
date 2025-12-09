function Debug-ForEachParallel {
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

        @(1..5) |
        ForEach-Object {
            Write-Host $_
            Start-Sleep -Seconds 1
        }

        (Measure-Command {
            @(1..5) |
            ForEach-Object {
                Write-Host $_
                Start-Sleep -Seconds 1
            }
        }).Seconds

        @(1..5) |
        ForEach-Object -Parallel {
            Write-Host $_
            Start-Sleep -Seconds 1
        } -ThrottleLimit 5

        (Measure-Command {
            @(1..5) |
            ForEach-Object -Parallel {
                Write-Host $_
                Start-Sleep -Seconds 1
            } -ThrottleLimit 5
        }).Seconds
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
Clear-Host
Wait-Debugger
Debug-ForEachParallel
