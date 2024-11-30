#requires -RunAsAdministrator
#requires -PSEdition Desktop

[CmdletBinding()]
param()
begin {
}
process {
    $Modules = @(
        "ActiveDirectoryCSDsc",
        "ActiveDirectoryDsc",
        "ComputerManagementDsc",
        "NetworkingDsc",
        "Pester",
        # "PSDesiredStateConfiguration",
        "SqlServerDsc",
        "xHyper-V"
    )
    foreach ($Module in $Modules) {
        Write-Output "Installing Module $Module"
        Install-Module -Name $Module -Scope AllUsers -Repository "PSGallery" -Force -WarningAction SilentlyContinue
    }
}
end {
}