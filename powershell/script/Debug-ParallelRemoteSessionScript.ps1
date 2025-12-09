param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Thumbprint
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Host "Doing Something ; Please Wait"

    Get-ChildItem -Path "Cert:\LocalMachine\My\$Thumbprint" |
    Select-Object -Property "Thumbprint", "NotBefore", "NotAfter", "Subject", "Issuer"
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
