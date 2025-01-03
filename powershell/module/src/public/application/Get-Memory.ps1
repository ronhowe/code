function Get-Memory {
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

        Get-WmiObject -Class "Win32_PhysicalMemory" |
        Select-Object -ExpandProperty "Capacity" |
        Measure-Object -Sum |
        Select-Object -Property @{Name = "MemoryGB"; Expression = { [Math]::Round($_.Sum / 1GB, 0) } }
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}