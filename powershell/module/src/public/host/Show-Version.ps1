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
    
        if ($PSVersionTable.PSEdition -eq "Core") {
            Write-Host "Running PowerShell Core $($PSVersionTable.PSVersion)" -ForegroundColor DarkGray
        }
        else {
            Write-Host "Running Windows PowerShell $($PSVersionTable.PSVersion)" -ForegroundColor DarkGray
        }
        Write-Host "Running Shell $(Get-Version)" -ForegroundColor DarkGray
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
