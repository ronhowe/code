[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Nodes,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [pscredential]
    $Credential
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    $scriptBlock = {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory = $false)]
            [ValidateNotNullorEmpty()]
            [string]
            $GatewayIpAddress = "192.168.0.1",

            [Parameter(Mandatory = $false)]
            [ValidateNotNullorEmpty()]
            [string]
            $PrefixLength = "24",

            [Parameter(Mandatory = $false)]
            [ValidateNotNullorEmpty()]
            [string]
            $PrimaryDnsIpAddress = "192.168.1.1"
        )
        begin {
            Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
        }
        process {
            Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

            $ErrorActionPreference = "Stop"

            ## NOTE: The redirection operator and output to $null suppress verbose import messages.
            ## NOTE: Using $env:COMPUTERNAME is a nice way to see the source of the messages.
            ## TODO: Can all of this be written as a script that is passed in instead of an inline scriptblock?
            Write-Host "Importing DnsClient Module On $env:COMPUTERNAME"
            Import-Module -Name "DnsClient"

            Write-Host "Importing NetAdapter Module On $env:COMPUTERNAME"
            Import-Module -Name "NetAdapter"

            Write-Host "Importing NetConnection Module On $env:COMPUTERNAME"
            Import-Module -Name "NetConnection"

            Write-Host "Importing NetTCPIP Module On $env:COMPUTERNAME"
            Import-Module -Name "NetTCPIP"

            ## TODO: This is setting the network to "Identifying..." and breaking the script.
            # Write-Verbose "Setting Network Profile Oo Private On $env:COMPUTERNAME"
            # Get-NetAdapter -Name "Ethernet" |
            # Set-NetConnectionProfile -NetworkCategory Private

            Write-Host "Setting Execution Policy To Unrestricted On $env:COMPUTERNAME"
            Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine -Force

            Write-Host "Enabling WinRM On $env:COMPUTERNAME"
            Start-Process -FilePath "winrm" -ArgumentList @("quickconfig", "-force") -Wait -NoNewWindow

            ## TODO: The IP should be passed in.
            Write-Host "Asserting Static IP Address On $env:COMPUTERNAME"
            $ipAddress =
            switch ($env:COMPUTERNAME) {
                "LAB-DC-00" { "192.168.0.10" }
                "LAB-APP-00" { "192.168.0.20" }
                "LAB-SQL-00" { "192.168.0.30" }
                "LAb-WEB-00" { "192.168.0.40" }
                default { throw }
            }
            Write-Debug "`$ipAddress = $ipAddress"

            Write-Host "Asserting Net Adapter Interface On $env:COMPUTERNAME"
            $interfaceIndex = (Get-NetAdapter -Name "Ethernet").ifIndex
            Write-Debug "`$interfaceIndex = $interfaceIndex"

            Write-Host "Setting Net Connection Profile To Private On $env:COMPUTERNAME"
            Set-NetConnectionProfile -InterfaceIndex $interfaceIndex -NetworkCategory "Private"

            Write-Host "Removing Net IP Address On $env:COMPUTERNAME"
            Remove-NetIPAddress -InterfaceIndex $interfaceIndex -Confirm:$false -ErrorAction Continue

            Write-Host "Removing Net Route On $env:COMPUTERNAME"
            Remove-NetRoute -InterfaceIndex $interfaceIndex -Confirm:$false -ErrorAction Continue

            ## TODO: The gateway IP and subnet mask should be passed in.
            Write-Host "Creating Net IP Address $ipAddress On $env:COMPUTERNAME"
            New-NetIPAddress -IPAddress $ipAddress -AddressFamily IPv4 -PrefixLength $PrefixLength -InterfaceIndex $interfaceIndex -DefaultGateway $GatewayIpAddress |
            Out-Null

            ## TODO: The DNS IP should be passed in.
            Write-Host "Setting DNS Client Server Address On $env:COMPUTERNAME"
            Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses ($PrimaryDnsIpAddress)

            Write-Host "Enabling Remote Desktop On $env:COMPUTERNAME"
            Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0

            Write-Host "Configuring Firewall To Allow Remote Desktop On $env:COMPUTERNAME"
            Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
        }
        end {
            Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
        }
    }

    Write-Host "Initializing Guests ; Please Wait"
    Invoke-Command -VMName $Nodes -Credential $Credential -ScriptBlock $scriptBlock
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
