function Connect-AzureAccount {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Tenant = $ShellConfig.Tenant,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Subscription = $ShellConfig.Subscription
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        Write-Verbose "Connecting Azure Account"
        Connect-AzAccount -Tenant $Tenant -Subscription $Subscription -UseDeviceAuthentication |
        Out-Null
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
