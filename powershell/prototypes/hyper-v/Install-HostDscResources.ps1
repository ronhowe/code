function Install-HostDscResources {
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

        Write-Verbose "Installing ActiveDirectoryCSDsc Dsc Resource"
        Install-Module -Name "ActiveDirectoryCSDsc" -RequiredVersion "5.0.0" -Repository "PSGallery" -Scope AllUsers -Force

        Write-Verbose "Installing ActiveDirectoryDsc Dsc Resource"
        Install-Module -Name "ActiveDirectoryDsc" -RequiredVersion "6.6.0" -Repository "PSGallery" -Scope AllUsers -Force

        Write-Verbose "Installing ComputerManagementDsc Dsc Resource"
        Install-Module -Name "ComputerManagementDsc" -RequiredVersion "9.2.0" -Repository "PSGallery" -Scope AllUsers -Force

        Write-Verbose "Installing NetworkingDsc Dsc Resource"
        Install-Module -Name "NetworkingDsc" -RequiredVersion "9.0.0" -Repository "PSGallery" -Scope AllUsers -Force

        Write-Verbose "Installing SqlServerDsc Dsc Resource"
        Install-Module -Name "SqlServerDsc" -RequiredVersion "17.0.0" -Repository "PSGallery" -Scope AllUsers -Force

        Write-Verbose "Installing xHyper-V Dsc Resource"
        Install-Module -Name "xHyper-V" -RequiredVersion "3.18.0" -Repository "PSGallery" -Scope AllUsers -Force
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
