#requires -Module "Az.Accounts"
#requires -Module "Az.Resources"

[CmdletBinding()]
param(
    [ValidateNotNullOrEmpty()]
    [string]
    $ResourceGroupName = "rg-ronhowe-0"
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
        Write-Verbose "Removing Azure Resource Group"
        Remove-AzResourceGroup -Name $ResourceGroupName -Force
    }
    catch {
        Write-Error "Removal Failed Because $($_.Exception.Message)"
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
