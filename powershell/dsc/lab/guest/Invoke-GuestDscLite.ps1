#requires -Module "PSDesiredStateConfiguration"
#requires -PSEdition "Desktop"
#requires -RunAsAdministrator
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

    [switch]
    $PublishOnly,

    [switch]
    $Wait
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Verbose "Creating Mof Folder"
    if (-not (Test-Path "$PSScriptRoot\bin\GuestDscLite")) {
        New-Item -Path "$PSScriptRoot\bin\GuestDscLite" -ItemType Directory
    }

    Write-Verbose "Importing Guest Dsc Lite"
    Import-Module -Name "$PSScriptRoot\GuestDscLite.psm1" -Force -Verbose

    Write-Verbose "Compiling Guest Dsc Lite"
    $parameters = @{
        ConfigurationData = "$PSScriptRoot\GuestDscLite.psd1"
        OutputPath        = "$PSScriptRoot\bin\GuestDscLite"
        Credential        = $Credential
    }
    GuestDscLite @parameters

    Write-Verbose "Invoking Guest Dsc Lite On $node"
    foreach ($node in $Nodes) {
        if ($PublishOnly) {
            Write-Verbose "Publishing Guest Dsc Lite On $node"
            Publish-DscConfiguration -ComputerName $node -Credential $Credential -Path "$PSScriptRoot\bin\GuestDscLite" -Force -Verbose |
            Out-Null
        }
        else {
            Write-Verbose "Starting Guest Dsc Lite On $node"
            Start-DscConfiguration -ComputerName $node -Credential $Credential -Path "$PSScriptRoot\bin\GuestDscLite" -Force -Wait:$Wait -Verbose |
            Out-Null
        }
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
