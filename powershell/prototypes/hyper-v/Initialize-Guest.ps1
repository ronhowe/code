function Initialize-Guest {
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
        Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"
    
        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

        $scriptBlock = {
            [CmdletBinding()]
            param(
                [Parameter(Mandatory = $false)]
                [ValidateSet("Continue", "SilentlyContinue")]
                [string]
                $ScriptBlockVerbosePreference = "SilentlyContinue",

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
                $VerbosePreference = $ScriptBlockVerbosePreference

                Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

                Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
                Select-Object -Property @("Name", "Value") |
                ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
            }
            process {
                Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

                $ErrorActionPreference = "Stop"

                ## NOTE: The redirection operator and output to $null suppress verbose import messages.
                ## NOTE: Using $env:COMPUTERNAME is a nice way to see the source of the messages.
                ## TODO: Can all of this be written as a script that is passed in instead of an inline scriptblock?
                Write-Verbose "Importing DnsClient Module On $env:COMPUTERNAME"
                Import-Module -Name "DnsClient" -Verbose:$false 4>&1 |
                Out-Null

                Write-Verbose "Importing NetAdapter Module On $env:COMPUTERNAME"
                Import-Module -Name "NetAdapter" -Verbose:$false 4>&1 |
                Out-Null

                Write-Verbose "Importing NetConnection Module On $env:COMPUTERNAME"
                Import-Module -Name "NetConnection" -Verbose:$false 4>&1 |
                Out-Null

                Write-Verbose "Importing NetTCPIP Module On $env:COMPUTERNAME"
                Import-Module -Name "NetTCPIP" -Verbose:$false 4>&1 |
                Out-Null

                ## TODO: This is setting the network to "Identifying..." and breaking the script.
                # Write-Verbose "Setting Network Profile Oo Private On $env:COMPUTERNAME"
                # Get-NetAdapter -Name "Ethernet" |
                # Set-NetConnectionProfile -NetworkCategory Private

                Write-Verbose "Enabling WinRM On $env:COMPUTERNAME"
                Start-Process -FilePath "winrm" -ArgumentList @("quickconfig", "-force") -Wait -NoNewWindow

                Write-Verbose "Setting Execution Policy To Unrestricted On $env:COMPUTERNAME"
                Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine -Force

                ## TODO: The IP should be passed in.
                Write-Verbose "Asserting Static IP Address On $env:COMPUTERNAME"
                $ipAddress =
                switch ($env:COMPUTERNAME) {
                    "LAB-DC-00" { "192.168.0.10" }
                    "LAB-APP-00" { "192.168.0.20" }
                    "LAB-SQL-00" { "192.168.0.30" }
                    "LAb-WEB-00" { "192.168.0.40" }
                    default { throw }
                }
                Write-Debug "`$ipAddress = $ipAddress"

                Write-Verbose "Asserting Net Adapter Interface On $env:COMPUTERNAME"
                $interfaceIndex = $(Get-NetAdapter -Name "Ethernet").ifIndex
                Write-Debug "`$interfaceIndex = $interfaceIndex"

                Write-Verbose "Removing Net IP Address On $env:COMPUTERNAME"
                Remove-NetIPAddress -InterfaceIndex $interfaceIndex -Confirm:$false -ErrorAction Continue

                Write-Verbose "Removing Net Route On $env:COMPUTERNAME"
                Remove-NetRoute -InterfaceIndex $interfaceIndex -Confirm:$false -ErrorAction Continue

                ## TODO: The gateway IP and subnet mask should be passed in.
                Write-Verbose "Creating Net IP Address On $env:COMPUTERNAME"
                New-NetIPAddress -IPAddress $ipAddress -AddressFamily IPv4 -PrefixLength $PrefixLength -InterfaceIndex $interfaceIndex -DefaultGateway $GatewayIpAddress |
                Out-Null

                ## TODO: The DNS IP should be passed in.
                Write-Verbose "Setting DNS Client Server Address On $env:COMPUTERNAME"
                Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses ($PrimaryDnsIpAddress) |
                Out-Null
            }
            end {
                Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
            }
        }

        Write-Verbose "Initializing Guests ; Please Wait"
        $parameters = @{
            VMName       = $Nodes
            Credential   = $Credential
            ScriptBlock  = $scriptBlock
            ArgumentList = @(
                $VerbosePreference
                ## TODO: Pass in instead of using the defaults.
                # $GatewayIpAddress,
                # $PrefixLength,
                # $PrimaryDnsIpAddress
            )
            Verbose      = $true
        }
        Invoke-Command @parameters
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
