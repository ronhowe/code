## LINK: https://devblogs.microsoft.com/powershell-community/encrypting-secrets-locally/
function Protect-WithUserKey {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $UnencryptedSecret
    )
    begin {
        Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

        Add-Type -AssemblyName System.Security
        $bytes = [System.Text.Encoding]::Unicode.GetBytes($UnencryptedSecret)
        $SecureStr = [Security.Cryptography.ProtectedData]::Protect(
            $bytes, # contains data to encrypt
            $null, # optional data to increase entropy
            [Security.Cryptography.DataProtectionScope]::CurrentUser # scope of the encryption
        )
        $SecureStrBase64 = [System.Convert]::ToBase64String($SecureStr)
        return $SecureStrBase64
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
