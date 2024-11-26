# https://devblogs.microsoft.com/powershell-community/encrypting-secrets-locally/
Function Protect-WithUserKey {
    param(
        [Parameter(Mandatory = $true)]
        [string]$secret
    )
    Add-Type -AssemblyName System.Security
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($secret)
    $SecureStr = [Security.Cryptography.ProtectedData]::Protect(
        $bytes, # contains data to encrypt
        $null, # optional data to increase entropy
        [Security.Cryptography.DataProtectionScope]::CurrentUser # scope of the encryption
    )
    $SecureStrBase64 = [System.Convert]::ToBase64String($SecureStr)
    return $SecureStrBase64
}
