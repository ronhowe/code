function Remove-Lab {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Nodes
    )
    begin {
        Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

        Write-Verbose "Stopping Virtual Machines"
        $Nodes |
        Stop-VM -TurnOff -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

        Write-Verbose "Invoking Host Dsc Ensuring Absent"
        Invoke-HostDsc -Nodes $Nodes -Ensure "Absent" -Wait
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
