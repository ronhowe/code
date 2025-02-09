function Show-Header {
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

        Write-Host "********************************************************************************" -ForegroundColor Green
        Write-Host "https://github.com/ronhowe" -ForegroundColor Green
        Write-Host "********************************************************************************" -ForegroundColor Green
        }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
