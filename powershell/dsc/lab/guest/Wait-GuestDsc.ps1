[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [string[]]
    $Nodes,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [pscredential]
    $Credential,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullorEmpty()]
    [int]
    $RetryInterval = 60
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    if ($Nodes -is [array]) {
        $expectedCount = $Nodes.Length
    }
    else {
        $expectedCount = 1
    }
    Write-Debug "`$expectedCount = $expectedCount"

    $scriptBlock = {
        $ProgressPreference = "SilentlyContinue"
        Write-Host "Starting DSC Configuration On $env:COMPUTERNAME"
        Start-DscConfiguration -UseExisting -Wait -ErrorAction SilentlyContinue
        Write-Host "Getting DSC Configuration Status On $env:COMPUTERNAME"
        return New-Object -TypeName "PSObject" -Property  @{ Status = (Get-DscConfigurationStatus -ErrorAction SilentlyContinue).Status }
    }

    Write-Host "Getting Guest Dsc Success Status Count ; Please Wait"
    $count = Invoke-Command -ComputerName $Nodes -Credential $Credential -ScriptBlock $scriptBlock -ErrorAction SilentlyContinue |
    Where-Object { $_.Status -eq "Success" } |
    Group-Object -Property "Status" |
    Select-Object -ExpandProperty "Count"

    while ($count -ne $expectedCount) {
        Write-Host "Recounting In $RetryInterval Seconds ; Please Wait"
        Start-Sleep -Seconds $RetryInterval

        Write-Host "Getting Guest Dsc Success Status Count ; Please Wait"
        $count = Invoke-Command -ComputerName $Nodes -Credential $Credential -ScriptBlock $scriptBlock -ErrorAction SilentlyContinue |
        Where-Object { $_.Status -eq "Success" } |
        Group-Object -Property "Status" |
        Select-Object -ExpandProperty "Count"
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
