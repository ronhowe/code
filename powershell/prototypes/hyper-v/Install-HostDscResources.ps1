[CmdletBinding()]
param(
)
begin {
    Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

    Write-Verbose "Installing Dsc Resources"
    @(
        "ActiveDirectoryCSDsc",
        "ActiveDirectoryDsc",
        "ComputerManagementDsc",
        "NetworkingDsc",
        "SqlServerDsc",
        "xHyper-V"
    ) |
    ForEach-Object {
        Write-Verbose "Installing Dsc Resource $_"
        Install-Module -Name $_ -Repository "PSGallery" -Scope AllUsers -Force
    }
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
