#requires -Module "Az.Accounts"
#requires -Module "Az.Resources"

[CmdletBinding()]
param(
    [ValidateNotNullOrEmpty()]
    [string]
    $ResourceGroupName = "rg-ronhowe-0",

    [ValidateNotNullOrEmpty()]
    [string]
    $AppConfigurationName = "appc-ronhowe-0"
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
        Write-Verbose "Getting Azure App Configuration Resource"
        $appConfig = Get-AzResource -ResourceType "Microsoft.AppConfiguration/configurationStores" -ResourceName $AppConfigurationName -ResourceGroupName $ResourceGroupName

        if ($appConfig) {
            Write-Verbose "Removing Azure App Configuration Resource"
            Remove-AzResource -ResourceId $appConfig.ResourceId -Force

            Write-Verbose "Removing Azure App Configuration Store"
            Remove-AzDeletedAppConfigurationStore -ResourceGroupName $ResourceGroupName -Name $AppConfigurationName -Force
        }
        else {
            Write-Warning "App Configuration Not Found"
        }
    }
    catch {
        Write-Error "Removal Failed Because $($_.Exception.Message)"
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}