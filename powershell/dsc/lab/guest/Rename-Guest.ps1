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
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    foreach ($node in $Nodes) {
        Write-Host "Renaming Computer $node ; Please Wait"
        $scriptBlock = {
            Rename-Computer -NewName $using:node
        }
        Invoke-Command -VMName $node -Credential $Credential -ScriptBlock $scriptBlock

        Write-Host "Restarting VM $node ; Please Wait"
        Restart-VM -Name $node -Wait -Force
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
