function Publish-DscEncryptionCertificate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullorEmpty()]
        [string[]]
        $Nodes,
    
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [pscredential]
        $Credential,
    
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [string]
        $PfxPath,
    
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [securestring]
        $PfxPassword
    )
    begin {
        Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

        foreach ($node in $Nodes) {
            Write-Verbose "Getting PSSession To $node"
            $session = New-PSSession -ComputerName $node -Credential $Credential

            Write-Verbose "Copying PFX To $node"
            Copy-Item -Path $PfxPath -Destination "C:\DscPrivateKey.pfx" -ToSession $session

            Write-Verbose "Importing PFX On $node"
            $ScriptBlock = {
                Import-PfxCertificate -FilePath "C:\DscPrivateKey.pfx" -CertStoreLocation "Cert:\LocalMachine\My" -Password $using:PfxPassword |
                Out-Null
            }
            Invoke-Command -Session $session -ScriptBlock $ScriptBlock

            Write-Verbose "Removing PSSession To $node"
            $session |
            Remove-PSSession
        }
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
