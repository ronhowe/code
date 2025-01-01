function Invoke-GuestDsc {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Nodes,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [pscredential]
        $Credential,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [string]
        $DscEncryptionCertificateThumbprint,

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

        Write-Verbose "Importing Guest Dsc"
        . "$PSScriptRoot\GuestDsc.ps1" -Verbose:$false 4>&1 |
        Out-Null

        Write-Verbose "Compiling Guest Dsc"
        $parameters = @{
            ConfigurationData                  = "$PSScriptRoot\GuestDsc.psd1"
            OutputPath                         = "$env:TEMP\GuestDsc"
            Credential                         = $Credential
            DscEncryptionCertificateThumbprint = $DscEncryptionCertificateThumbprint
        }
        GuestDsc @parameters |
        Out-Null

        Write-Verbose "Invoking Guest Dsc On $node"
        foreach ($node in $Nodes) {
            Write-Verbose "Setting Guest Dsc Local Configuration Manager On $node"
            Set-DscLocalConfigurationManager -ComputerName $node -Credential $Credential -Path "$env:TEMP\GuestDsc" -Force

            Write-Verbose "Starting Guest Dsc On $node"
            Start-DscConfiguration -ComputerName $node -Credential $Credential -Path "$env:TEMP\GuestDsc" -Force -Wait:$Wait
        }
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
