#requires -Module "Az.Accounts"

[CmdletBinding()]
param()

Write-Verbose "Disconnecting Azure Account"
Disconnect-AzAccount
