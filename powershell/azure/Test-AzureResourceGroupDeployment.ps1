#requires -Module "Az.Accounts"
#requires -Module "Az.Resources"

[CmdletBinding()]
param(
    [ValidateNotNullOrEmpty()]
    [string]
    $ResourceGroupName = "rg-ronhowe-0",

    [ValidateNotNullOrEmpty()]
    [string]
    $Location = "eastus2",

    [ValidateNotNullOrEmpty()]
    [string]
    $DeploymentName = "MyDeployment"
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
        Write-Verbose "Testing Azure Resource Group Deployment"
        $parameters = @{
            ResourceGroupName     = $ResourceGroupName
            Location              = $Location
            TemplateFile          = "$HOME\repos\ronhowe\code\azure\template.bicep"
            TemplateParameterFile = "$HOME\repos\ronhowe\code\azure\parameters.json"
            Mode                  = "Incremental"
            Verbose               = $false
        }
        Test-AzResourceGroupDeployment @parameters
    }
    catch {
        Write-Error "Deployment Failed Because $($_.Exception.Message)"
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
