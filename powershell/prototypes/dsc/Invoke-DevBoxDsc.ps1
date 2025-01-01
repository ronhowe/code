function Invoke-DevBoxDsc {
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

        Write-Verbose "Importing DevBox Dsc"
        . "$PSScriptRoot\DevBoxDsc.ps1" -Verbose:$false 4>&1 |
        Out-Null

        Write-Verbose "Compiling DevBox Dsc"
        DevBoxDsc -ConfigurationData "$PSScriptRoot\DevBoxDsc.psd1" -OutputPath "$env:TEMP\DevBoxDsc" |
        Out-Null

        Write-Verbose "Starting DevBox Dsc"
        Start-DscConfiguration -Path "$env:TEMP\DevBoxDsc" -Force -Wait:$Wait
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
