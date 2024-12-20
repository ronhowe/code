#requires -Module "Az.Accounts"
#requires -Module "Az.Resources"

[CmdletBinding()]
param(
    [ValidateNotNullOrEmpty()]
    [string]
    $ResourceGroupName = "rg-ronhowe-0",

    [ValidateNotNullOrEmpty()]
    [string]
    $Location = "eastus2"
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
        Write-Verbose "Creating Azure Resource Group"
        New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Force
    }
    catch {
        Write-Error "Creation Failed Because $($_.Exception.Message)"
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
