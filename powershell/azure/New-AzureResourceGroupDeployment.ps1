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
    Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

    try {
        Write-Verbose "Adding Azure Resource Group Deployment"
        $parameters = @{
            ResourceGroupName     = $ResourceGroupName
            Location              = $Location
            DeploymentName        = $DeploymentName
            TemplateFile          = "$HOME\repos\ronhowe\code\azure\template.bicep"
            TemplateParameterFile = "$HOME\repos\ronhowe\code\azure\parameters.json"
            Mode                  = "Incremental"
            Force                 = $true
            Verbose               = $false
        }
        New-AzResourceGroupDeployment @parameters
    }
    catch {
        Write-Error "Deployment Failed Because $($_.Exception.Message)"
    }
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
