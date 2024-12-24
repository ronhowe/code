#requires -Module "Pester"
#requires -Module "Shell"
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

    ## TODO: Remove \module\ such as to include \dependencies\ Pester tests?
    Get-ChildItem -Path "$PSScriptRoot\Tests\*.Tests.ps1" -Recurse |
    ForEach-Object {
        Invoke-Pester -Path $($_.FullName) -Output Detailed
    }
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
