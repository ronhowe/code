function Show-Version {
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
    
        Write-Host $(Get-Version) -ForegroundColor DarkGray
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
