## LINK: https://devblogs.microsoft.com/powershell-community/encrypting-secrets-locally/
function Unprotect-WithUserKey {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $EncryptedSecret
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        Add-Type -AssemblyName System.Security
        $secureString = [System.Convert]::FromBase64String($EncryptedSecret)
        $bytes = [Security.Cryptography.ProtectedData]::Unprotect(
            $secureString, # bytes to decrypt
            $null, # optional entropy data
            [Security.Cryptography.DataProtectionScope]::CurrentUser) # scope of the decryption
        $secret = [System.Text.Encoding]::Unicode.GetString($bytes)
        return $secret
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
