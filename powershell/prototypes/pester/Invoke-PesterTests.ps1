#requires -Module "Pester"

Get-ChildItem -Path "$PSScriptRoot\*.Tests.ps1" |
ForEach-Object {
    Invoke-Pester -Path $($_.FullName) -Output Detailed
}
