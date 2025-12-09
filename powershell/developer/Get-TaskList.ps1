[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    $Path = @(
        "$HOME\repos\ronhowe\azure",
        "$HOME\repos\ronhowe\dev",
        "$HOME\repos\ronhowe\dotnet",
        "$HOME\repos\ronhowe\powershell",
        "$HOME\repos\ronhowe\roll20",
        "$HOME\repos\ronhowe\ronhowe",
        "$HOME\repos\ronhowe\sql"
    )
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    ## TODO: Add ability to exclude filters by -Skip* parameters.
    Get-ChildItem -Path $Path -Include @("*.bicep", "*.cs", "*.json", "*.md", "*.ps*", "*.sql", "*.txt", "*.xml") -Recurse |
    Where-Object { $_.FullName -notlike "*\bin\*" -and $_.FullName -notlike "*\obj\*" } |
    Sort-Object -Property "FullName" |
    Select-String -Pattern "(LINK|NOTE|TODO)" -CaseSensitive |
    Select-Object -Property @("Path", @{Name = "Line"; Expression = { $_.Line.Trim() } }) |
    Where-Object { $_.Line -notlike "*(LINK|NOTE|TODO)*" }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
