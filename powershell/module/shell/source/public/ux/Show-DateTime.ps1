function Show-DateTime {
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

        Write-Host "$([DateTime]::Now.ToString(`"yyyy-MM-dd HH:mm:ss.fff`")) (LOCAL)"
        Write-Host "$([DateTime]::UtcNow.ToString(`"yyyy-MM-dd HH:mm:ss.fff`")) (UTC)"
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}

New-Alias -Name "date" -Value "Show-DateTime" -Force -Scope Global
New-Alias -Name "time" -Value "Show-DateTime" -Force -Scope Global
