# https://sid-500.com/2017/10/29/powershell-encrypt-and-decrypt-data/#:~:text=PowerShell%3A%20Encrypt%20and%20Decrypt%20Data%20by%20using%20Certificates,data%20run%20Unprotect-CmsMessage.%20...%205%20See%20also.%20

Push-Location -Path $env:TEMP

New-SelfSignedCertificate -DnsName "foo" -CertStoreLocation "Cert:\CurrentUser\My" -KeyUsage KeyEncipherment, DataEncipherment, KeyAgreement -Type DocumentEncryptionCert

Get-Childitem -Path "Cert:\CurrentUser\My" -DocumentEncryptionCert

"This is a secret message" | Protect-CmsMessage -To "CN=foo" -OutFile ".\secret.txt"

Get-Content -Path ".\secret.txt"

Unprotect-CmsMessage -Path ".\secret.txt"

Get-Childitem -Path "Cert:\CurrentUser\My" -DocumentEncryptionCert | Remove-Item

Pop-Location
