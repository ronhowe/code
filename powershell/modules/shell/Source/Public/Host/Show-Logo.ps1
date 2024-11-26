function Show-Logo {
    [CmdletBinding()]
    param (
    )
    begin {
        Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
    }
    process {
        Write-Debug "Process $($MyInvocation.MyCommand.Name)"

        Write-Host "r" -BackgroundColor Red -ForegroundColor Black -NoNewline
        Write-Host "o" -BackgroundColor DarkYellow -ForegroundColor Black -NoNewline
        Write-Host "n" -BackgroundColor Yellow -ForegroundColor Black -NoNewline
        Write-Host "h" -BackgroundColor Green -ForegroundColor Black -NoNewline
        Write-Host "o" -BackgroundColor DarkBlue -ForegroundColor Black -NoNewline
        Write-Host "w" -BackgroundColor Blue -ForegroundColor Black -NoNewline
        Write-Host "e" -BackgroundColor Cyan -ForegroundColor Black -NoNewline
        Write-Host ".net"
    }
    end {
        Write-Debug "End $($MyInvocation.MyCommand.Name)"
    }
}
