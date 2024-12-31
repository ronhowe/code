function Remove-AzureKeyVault {
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [string]
        $ResourceGroupName = $ShellConfig.ResourceGroupName,

        [ValidateNotNullOrEmpty()]
        [string]
        $Location = $ShellConfig.Location,

        [ValidateNotNullOrEmpty()]
        [string]
        $KeyVaultName = $ShellConfig.KeyVaultName
    )
    begin {
        Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

        try {
            Write-Verbose "Removing Azure Key Vault ; Please Wait"
            Remove-AzKeyVault -VaultName $KeyVaultName -Location $Location -ResourceGroupName $ResourceGroupName -Force

            Write-Verbose "Purging Azure Key Vault ; Please Wait"
            Remove-AzKeyVault -VaultName $KeyVaultName -Location $Location -InRemovedState -Force
        }
        catch {
            Write-Error "Removal Failed Because $($_.Exception.Message)"
        }
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
