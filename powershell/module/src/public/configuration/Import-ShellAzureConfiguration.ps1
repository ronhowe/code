function Import-ShellAzureConfiguration {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path -Path $_ })]
        [string]
        $Path = "$HOME\repos\ronhowe\code\azure\parameters.json"
    )
    begin {
        Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

        Write-Verbose "Importing Parameters JSON"
        $parameters = Get-Content -Path $Path |
        ConvertFrom-Json |
        Select-object -ExpandProperty "parameters"

        Write-Verbose "Setting Shell Configuration"
        ## TODO: Add all Azure resource names to ShellConfig.
        $global:ShellConfig.Location = $parameters.location.value;
        $global:ShellConfig.AppConfigurationName = $parameters.configStoreName.value;
        $global:ShellConfig.AutomationAccountName = $parameters.automationAccountName.value;
        $global:ShellConfig.FileShareName = $parameters.fileShareName.value;
        $global:ShellConfig.KeyVaultName = $parameters.keyVaultName.value;
        $global:ShellConfig.StorageAccountName = $parameters.storageAccountName.value;

        Write-Verbose "Returning Shell Configuration"
        return $global:ShellConfig
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}