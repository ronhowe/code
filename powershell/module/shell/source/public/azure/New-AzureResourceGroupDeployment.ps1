function New-AzureResourceGroupDeployment {
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
        $DeploymentName = $ShellConfig.DeploymentName
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
            Write-Verbose "Adding Azure Resource Group Deployment ; Please Wait"
            $parameters = @{
                ResourceGroupName     = $ResourceGroupName
                Location              = $Location
                DeploymentName        = $DeploymentName
                TemplateFile          = "$HOME\repos\ronhowe\azure\resource\template.bicep"
                TemplateParameterFile = "$HOME\repos\ronhowe\azure\resource\parameters.json"
                Mode                  = "Incremental"
                Force                 = $true
                Verbose               = $false
            }
            New-AzResourceGroupDeployment @parameters |
            Out-Null
        }
        catch {
            Write-Error "Deployment Failed Because $($_.Exception.Message)"
        }
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
