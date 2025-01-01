function Invoke-HostDsc {
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

        Write-Verbose "Importing Host Dsc"
        . "$PSScriptRoot\HostDsc.ps1" -Verbose:$false 4>&1 |
        Out-Null

        Write-Verbose "Compiling Host Dsc"
        HostDsc -ConfigurationData "$PSScriptRoot\HostDsc.psd1" -Nodes $Nodes -Ensure $Ensure -OutputPath "$env:TEMP\HostDsc" |
        Out-Null

        Write-Verbose "Starting Host Dsc"
        Start-DscConfiguration -Path "$env:TEMP\HostDsc" -Force -Wait:$Wait
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
