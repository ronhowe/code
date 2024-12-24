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

    $identity = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent())

    if (-not $identity.IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
        throw [System.UnauthorizedAccessException] "Not Running As Administrator"
    }
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
