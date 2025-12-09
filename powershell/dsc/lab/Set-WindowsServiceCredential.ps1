[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Name,

    [Parameter(Mandatory = $true)]
    [pscredential]
    $Credential
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    if (($Name -eq "MSSQLSERVER") -or ($Name -eq "SQLSERVERAGENT")) {
        Write-Warning "Altering Windows service credential for MSSQLSERVER is not recommended (except password resets)." -WarningAction Continue
        Write-Warning "Use SQL Server Configuration Manager instead." -WarningAction Continue
    }

    Write-Host "Setting Credential On $env:COMPUTERNAME For Service $Name"
    & sc.exe config "$Name" obj= "$($Credential.Username)" password= "$($Credential.GetNetworkCredential().Password)"
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
