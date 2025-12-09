function Test-AzureResourceGroupDeployment {
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
            Write-Verbose "Testing Azure Resource Group Deployment"
            $parameters = @{
                ResourceGroupName     = $ResourceGroupName
                Location              = $Location
                ## TODO: Replace references with $Env:SHELL_CODE_PATH variable.
                TemplateFile          = "$HOME\repos\ronhowe\azure\resource\template.bicep"
                TemplateParameterFile = "$HOME\repos\ronhowe\azure\resource\parameters.json"
                Mode                  = "Incremental"
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
}
