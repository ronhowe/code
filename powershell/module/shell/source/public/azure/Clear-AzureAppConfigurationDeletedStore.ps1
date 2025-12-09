function Clear-AzureAppConfigurationDeletedStore {
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [string]
        $Location = $ShellConfig.Location,

        [ValidateNotNullOrEmpty()]
        [string]
        $AppConfigurationName = $ShellConfig.AppConfigurationName
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        try {
            Write-Verbose "Clearing Azure App Configuration Deleted Store"
            Clear-AzAppConfigurationDeletedStore -Location $Location -Name $AppConfigurationName
        }
        catch {
            Write-Error "Removal Failed Because $($_.Exception.Message)"
        }
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
