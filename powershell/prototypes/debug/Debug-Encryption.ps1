throw

# https://sid-500.com/2017/10/29/powershell-encrypt-and-decrypt-data/#:~:text=PowerShell%3A%20Encrypt%20and%20Decrypt%20Data%20by%20using%20Certificates,data%20run%20Unprotect-CmsMessage.%20...%205%20See%20also.%20

$parameters = @{
    DnsName = "MOCKDNSNAME.COM"
    CertStoreLocation = "Cert:\CurrentUser\My"
    KeyUsage = @( "KeyEncipherment", "DataEncipherment", "KeyAgreement" )
    Type = "DocumentEncryptionCert"
}
$certificate = New-SelfSignedCertificate @parameters

$certificate.Thumbprint

Get-Childitem -Path "Cert:\CurrentUser\My" -DocumentEncryptionCert

"This is a mock secret message." |
Protect-CmsMessage -To "CN=MOCKDNSNAME.COM" -OutFile "$env:TEMP\secret.txt"

Get-Content -Path "$env:TEMP\secret.txt"

Unprotect-CmsMessage -Path "$env:TEMP\secret.txt"

Get-Childitem -Path "Cert:\CurrentUser\My" -DocumentEncryptionCert |
Remove-Item
