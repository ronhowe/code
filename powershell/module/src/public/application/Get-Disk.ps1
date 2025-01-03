function Get-Disk {
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

        if (Test-RunAsPowerShellCore) {
            Import-Module -Name "Microsoft.PowerShell.Management" -Verbose:$false -UseWindowsPowerShell -WarningAction SilentlyContinue 4>&1 |
            Out-Null
        }

        Get-WmiObject -Class "Win32_LogicalDisk" |
        Select-Object -Property @{Name = "DriveLetter" ; Expression = { $_.DeviceID } },
        @{Name = "SizeGB" ; Expression = { [Math]::Round($_.Size / 1GB, 0) } },
        @{Name = "FreeGB" ; Expression = { [Math]::Round($_.FreeSpace / 1GB, 0) } },
        @{Name = "UsedGB" ; Expression = { [Math]::Round($($_.Size - $_.FreeSpace) / 1GB, 0) } } |
        Where-Object { $_.SizeGB -gt 0 }
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
