function New-DscEncryptionCertificate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [securestring]
        $PfxPassword,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullorEmpty()]
        [string]
        $CertStoreLocation = "Cert:\LocalMachine\My"
    )
    begin {
        Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

        Write-Warning "Creating Self-Signed Certificate"

        Write-Verbose "Creating Certificate"
        $certificate = New-SelfSignedCertificate -Type DocumentEncryptionCertLegacyCsp -DnsName "DscEncryptionCert" -HashAlgorithm SHA256
    
        Write-Verbose "Exporting Pfx Certificate"
        $certificate |
        Export-PfxCertificate -FilePath "$PSScriptRoot\DscPrivateKey.pfx" -Password $PfxPassword -Force
    
        Write-Verbose "Exporting Certificate"
        $certificate |
        Export-Certificate -FilePath "$PSScriptRoot\DscPublicKey.cer" -Force
    
        Write-Verbose "Removing Certificate"
        $certificate |
        Remove-Item -Force
    
        Write-Verbose "Importing Certificate"
        Import-Certificate -FilePath "$PSScriptRoot\DscPublicKey.cer" -CertStoreLocation $CertStoreLocation
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
