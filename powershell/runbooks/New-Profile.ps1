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

    Write-Verbose "Creating File"
    New-Item -Path $profile -ItemType File -Force -Verbose

    Write-Verbose "Setting Content"
    '. "$HOME\repos\ronhowe\code\powershell\profile.ps1"' |
    Set-Content -Path $profile -Force -Verbose

    Write-Verbose "Importing Profile"
    . $profile
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
