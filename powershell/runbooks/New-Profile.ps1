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

    Write-Debug "`$profile = $profile"

    Write-Verbose "Creating File"
    New-Item -Path $profile -ItemType File -Force |
    Out-Null

    Write-Verbose "Setting Content"
    '# auto-generated' |
    Set-Content -Path $profile -Force

    Write-Verbose "Appending Content"
    ". $(Resolve-Path -Path "$PSScriptRoot\..\profile.ps1")" |
    Add-Content -Path $profile

    Write-Verbose "Importing Profile"
    . $profile
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
