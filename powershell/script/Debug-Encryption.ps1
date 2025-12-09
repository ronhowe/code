function Debug-Encryption {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Message = "Mock Secret"
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        # https://sid-500.com/2017/10/29/powershell-encrypt-and-decrypt-data/#:~:text=PowerShell%3A%20Encrypt%20and%20Decrypt%20Data%20by%20using%20Certificates,data%20run%20Unprotect-CmsMessage.%20...%205%20See%20also.%20

        Write-Verbose "Creating Certificate"
        $parameters = @{
            DnsName           = "mockdnsname.com"
            CertStoreLocation = "Cert:\CurrentUser\My"
            KeyUsage          = @( "KeyEncipherment", "DataEncipherment", "KeyAgreement" )
            Type              = "DocumentEncryptionCert"
        }
        $certificate = New-SelfSignedCertificate @parameters
        $certificate.Thumbprint

        Write-Verbose "Getting Certificate"
        Get-Childitem -Path "Cert:\CurrentUser\My" -DocumentEncryptionCert

        Write-Verbose "Protecting Message"
        $Message |
        Protect-CmsMessage -To "CN=mockdnsname.com" -OutFile "$env:TEMP\secret.txt"

        Write-Verbose "Getting Encrypted Message"
        Get-Content -Path "$env:TEMP\secret.txt"

        Write-Verbose "Unprotecting Message"
        Unprotect-CmsMessage -Path "$env:TEMP\secret.txt"

        Write-Verbose "Removing Certificate"
        Get-Childitem -Path "Cert:\CurrentUser\My" -DocumentEncryptionCert |
        Remove-Item

    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
Clear-Host
Wait-Debugger
Debug-Encryption
