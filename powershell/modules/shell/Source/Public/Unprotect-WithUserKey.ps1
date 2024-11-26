# https://devblogs.microsoft.com/powershell-community/encrypting-secrets-locally/
Function Unprotect-WithUserKey {
    param (
        [Parameter(Mandatory = $true)]
        [string]$enc_secret
    )
    Add-Type -AssemblyName System.Security
    $SecureStr = [System.Convert]::FromBase64String($enc_secret)
    $bytes = [Security.Cryptography.ProtectedData]::Unprotect(
        $SecureStr, # bytes to decrypt
        $null, # optional entropy data
        [Security.Cryptography.DataProtectionScope]::CurrentUser) # scope of the decryption
    $secret = [System.Text.Encoding]::Unicode.GetString($bytes)
    return $secret
}
