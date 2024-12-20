#requires -Module "Az.Accounts"

[CmdletBinding()]
param(
    [ValidateNotNullOrEmpty()]
    [string]
    $TenantId = "c4112466-d0d8-405d-a9c8-6c44f4ab7ad3",

    [ValidateNotNullOrEmpty()]
    [string]
    $SubscriptionId = "73177ebd-c208-4211-87a3-f9e6ed0550c6"
)

Write-Verbose "Connecting To Azure Account"
Connect-AzAccount -Tenant $TenantId -Subscription $SubscriptionId -UseDeviceAuthentication
