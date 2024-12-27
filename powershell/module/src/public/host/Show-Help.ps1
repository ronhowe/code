function Show-Help {
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

        # sync with Aliases.ps1
        # sync with Aliases.Tests.ps1
        # sync with Show-Help.ps1
        Write-Host "api" -ForegroundColor Green
        Write-Host "catfact" -ForegroundColor Green
        Write-Host "date" -ForegroundColor Green
        Write-Host "go" -ForegroundColor Green
        Write-Host "header" -ForegroundColor Green
        Write-Host "help" -ForegroundColor Green
        Write-Host "home" -ForegroundColor Green
        Write-Host "line" -ForegroundColor Green
        Write-Host "list" -ForegroundColor Green
        Write-Host "logo" -ForegroundColor Green
        Write-Host "matrix" -ForegroundColor Green
        Write-Host "new" -ForegroundColor Green
        Write-Host "ok" -ForegroundColor Green
        Write-Host "oops" -ForegroundColor Green
        Write-Host "pong" -ForegroundColor Green
        Write-Host "quiet" -ForegroundColor Green
        Write-Host "repos" -ForegroundColor Green
        Write-Host "ronhowe" -ForegroundColor Green
        Write-Host "shell" -ForegroundColor Green
        Write-Host "silence" -ForegroundColor Green
        Write-Host "version" -ForegroundColor Green
        Write-Host "weather" -ForegroundColor Green
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
