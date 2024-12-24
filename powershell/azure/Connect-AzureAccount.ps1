#requires -Module "Az.Accounts"
[CmdletBinding()]
param(
    [ValidateNotNullOrEmpty()]
    [string]
    $TenantId = "d3efb988-727d-47ea-adb8-cce6dc17857d",

    [ValidateNotNullOrEmpty()]
    [string]
    $SubscriptionId = "32824cab-0279-4368-a5e3-d9921d3d1331"
)
begin {
    Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

    Write-Verbose "Connecting To Azure Account"
    Connect-AzAccount -Tenant $TenantId -Subscription $SubscriptionId -UseDeviceAuthentication
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
