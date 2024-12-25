function Start-Shell {
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
        try {
            # Write-Verbose "Importing Power Configuration"
    
            # https://github.com/JustinGrote/PowerConfig/issues/7
            # Import-PowerConfiguration -Name "Shell" -Path "$PSScriptRoot\Shell.json" |
            # Out-Null
    
            # Write-Verbose "Showing Configuration"
    
            # $ShellConfiguration |
            # Format-Table -AutoSize
    
            Write-Verbose "Starting Shell"
    
            Set-Location -Path $HOME
    
            Clear-Host
    
            Show-Logo
    
            Show-Date
    
            Show-Version
    
            Show-Ready
        }
        catch {
            Write-Error "Shell Failed Because $($_.Exception.Message)"
        }
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
