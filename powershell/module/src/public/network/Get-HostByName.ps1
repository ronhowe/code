function Get-HostByName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("Name", "VmName")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $ComputerName
    )
    begin {
        Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

        foreach ($computer in $ComputerName) {
            try {
                [System.Net.Dns]::GetHostByName($computer).HostName.ToUpper()
            }
            catch {
                Write-Error "Error converting $computer to fully qualified domain name."
            }
        }
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
