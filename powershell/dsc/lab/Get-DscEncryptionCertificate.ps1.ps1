#requires -PSEdition "Desktop"
#requires -RunAsAdministrator
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullorEmpty()]
    [string]
    $Subject = "DscEncryptionCert",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullorEmpty()]
    [string]
    $CertStoreLocation = "Cert:\LocalMachine\My"
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Verbose "Getting Certificate"
    Get-ChildItem -Path $CertStoreLocation |
    Where-Object { $_.Subject -eq "CN=$Subject" } |
    Select-Object -ExpandProperty "Thumbprint"
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
