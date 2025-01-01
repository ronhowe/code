function Rename-Guest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Nodes,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [pscredential]
        $Credential
    )
    begin {
        Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

        foreach ($node in $Nodes) {
            Write-Verbose "Renaming Computer $node ; Please Wait"
            $scriptBlock = {
                Rename-Computer -NewName $using:node -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
            }
            Invoke-Command -VMName $node -Credential $Credential -ScriptBlock $scriptBlock

            Write-Verbose "Restarting VM $node ; Please Wait"
            Restart-VM -Name $node -Wait -Force
        }
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
