[CmdletBinding()]
param(
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Verbose "Creating Profile"
    New-Item -Path $PROFILE -ItemType File -Force |
    Out-Null

    Write-Verbose "Setting Profile"
@'
# auto-generated
if (Test-Path -Path "$HOME\repos\ronhowe\code\powershell\profile\profile.ps1") {
    . $HOME\repos\ronhowe\code\powershell\profile\profile.ps1 -ErrorAction SilentlyContinue
}
'@ |
    Set-Content -Path $PROFILE -Force

    Write-Verbose "Loading Profile"
    . $PROFILE
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
