function Show-Version {
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
    
        if ($PSVersionTable.PSEdition -eq "Core") {
            Write-Host "Running PowerShell Core $($PSVersionTable.PSVersion)" -ForegroundColor DarkGray
        }
        else {
            Write-Host "Running Windows PowerShell $($PSVersionTable.PSVersion)" -ForegroundColor DarkGray
        }
        Write-Host "Running Shell $(Get-Version)" -ForegroundColor DarkGray
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
