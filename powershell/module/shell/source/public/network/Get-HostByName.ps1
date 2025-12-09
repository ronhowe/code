function Get-HostByName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("Name", "Node", "NodeName", "VMName")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $ComputerName
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        foreach ($computer in $ComputerName) {
            try {
                [System.Net.Dns]::GetHostByName($env:COMPUTERNAME) |
                Select-Object -Property @(@{Name = "ComputerName"; Expression = { $_.HostName.ToUpper() } })
            }
            catch {
                Write-Error "Failed Getting Host For $computer"
            }
        }
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
