[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Nodes,

    [Parameter(Mandatory = $true)]
    [ValidateSet("Present", "Absent")]
    [string]
    $Ensure,

    [switch]
    $Wait
)
begin {
    Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

    Write-Verbose "Importing Host Configuration"
    . "$PSScriptRoot\HostConfiguration.ps1"

    Write-Verbose "Compiling Host Configuration"
    HostConfiguration -ConfigurationData "$PSScriptRoot\HostConfiguration.psd1" -Nodes $Nodes -Ensure $Ensure -OutputPath "$env:TEMP\HostConfiguration" |
    Out-Null

    Write-Verbose "Starting Host Configuration"
    Start-DscConfiguration -Path "$env:TEMP\HostConfiguration" -Force -Wait:$Wait
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
