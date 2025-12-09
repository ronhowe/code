throw

Get-Module -Name "Shell"
Assert-RunAsAdministrator

Import-Module -Name "Hyper-V"

$nodes = Read-Host -Prompt "Enter Node Name"

$credential = Get-Credential -Message "Enter Administrator Credential" -UserName "Administrator"

Get-VM -Name $nodes

Invoke-Command -VMName $nodes -Credential $credential -ScriptBlock { $env:COMPUTERNAME }

Invoke-Command -VMName $nodes -Credential $credential -ScriptBlock { Rename-Computer -NewName $using:nodeName -Restart -Force }

$scriptBlock = {
    $ProgressPreference = "SilentlyContinue"
    Test-NetConnection
}
Invoke-Command -VMName $nodes -Credential $credential -ScriptBlock $scriptBlock

# Get the virtual machine IP addresses.
$LABDC00 = "192.168.0.10" ; $LABDC00 ; $ipAddress = $LABDC00
$LABAPP00 = "192.168.0.20" ; $LABAPP00 ; $ipAddress = $LABAPP00
$LABSQL00 = "192.168.0.30" ; $LABSQL00 ; $ipAddress = $LABSQL00
$LABWEB00 = "192.168.0.40" ; $LABWEB00 ; $ipAddress = $LABWEB00
## NOTE: Work shim.
$DOMAIN01 = "192.168.0.197" ; $DOMAIN01 ; $ipAddress = $DOMAIN01
$DOMAIN02 = "192.168.0.198" ; $DOMAIN02 ; $ipAddress = $DOMAIN02
$DOMAIN41 = "192.168.0.129" ; $DOMAIN41 ; $ipAddress = $DOMAIN41
$DOMAIN42 = "192.168.0.130" ; $DOMAIN42 ; $ipAddress = $DOMAIN42
# or
$ipAddress = Read-Host -Prompt "Enter IP Address"

# Get the gateway IP address.
$GATEWAY = "192.168.0.1" ; $GATEWAY ; $gatewayIpAddress = $GATEWAY
# or
$gatewayIpAddress = Read-Host -Prompt "Enter Gateway IP Address"

# Get the router IP address.
$ROUTER = "192.168.1.1" ; $ROUTER ; $routerIpAddress = $ROUTER
# or
$routerIpAddress = Read-Host -Prompt "Enter Router IP Address"

# Get the DNS IP addresses.
$PRIMARY = $LABDC00 ; $PRIMARY ; $primaryDnsIpAddress = $PRIMARY
$SECONDARY = $routerIpAddress; $SECONDARY ; $secondaryDnsIpAddress = $SECONDARY
# or
$PRIMARY = $DOMAIN01 ; $PRIMARY ; $primaryDnsIpAddress = $PRIMARY
$SECONDARY = $routerIpAddress; $SECONDARY ; $secondaryDnsIpAddress = $SECONDARY
# or
$primaryDnsIpAddress = Read-Host -Prompt "Enter Primary DNS IP Address"
$secondaryDnsIpAddress = Read-Host -Prompt "Enter Secondary DNS IP Address"

$primaryDnsIpAddress + " / " + $secondaryDnsIpAddress

$scriptBlock = {
    $ProgressPreference = "SilentlyContinue"
    $interfaceIndex = $(Get-NetAdapter -Name "Ethernet").ifIndex
    Remove-NetIPAddress -InterfaceIndex $interfaceIndex -Confirm:$false
    Remove-NetRoute -InterfaceIndex $interfaceIndex -Confirm:$false
    New-NetIPAddress -IPAddress $using:IpAddress -AddressFamily IPv4 -PrefixLength "24" -InterfaceIndex $interfaceIndex -DefaultGateway $using:gatewayIpAddress
    Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses ($using:primaryDnsIpAddress, $using:secondaryDnsIpAddress)
}
Invoke-Command -VMName $nodes -Credential $credential -ScriptBlock $scriptBlock

$scriptBlock = {
    $ProgressPreference = "SilentlyContinue"
    Test-NetConnection
}
Invoke-Command -VMName $nodes -Credential $credential -ScriptBlock $scriptBlock

Test-NetConnection -ComputerName $nodes -Port 5985 -WarningAction SilentlyContinue

$session = New-PSSession -ComputerName $nodes -Credential $credential

$session | Get-PSSession

$session | Enter-PSSession

$session | Remove-PSSession

$scriptBlock = {
    $ProgressPreference = "SilentlyContinue"
    Get-NetFirewallRule -DisplayName "Allow inbound ICMPv4"
    Get-NetFirewallRule -DisplayName "Allow inbound ICMPv6"
}
Invoke-Command -ComputerName $nodes -Credential $credential -ScriptBlock $scriptBlock

$scriptBlock = {
    $ProgressPreference = "SilentlyContinue"
    New-NetFirewallRule -DisplayName "Allow inbound ICMPv4" -Direction Inbound -Protocol ICMPv4 -IcmpType 8 -Action Allow
    New-NetFirewallRule -DisplayName "Allow inbound ICMPv6" -Direction Inbound -Protocol ICMPv6 -IcmpType 8 -Action Allow
}
Invoke-Command -ComputerName $nodes -Credential $credential -ScriptBlock $scriptBlock

Test-NetConnection -ComputerName $nodes -WarningAction SilentlyContinue

$scriptBlock = {
    Get-TimeZone
}
Invoke-Command -ComputerName $nodes -Credential $credential -ScriptBlock $scriptBlock

$scriptBlock = {
    Set-TimeZone -Name "Coordinated Universal Time"
    # Set-TimeZone -Name "Eastern Standard Time"
}
Invoke-Command -ComputerName $nodes -Credential $credential -ScriptBlock $scriptBlock

Invoke-Command -ComputerName $nodes -Credential $credential -ScriptBlock { pwsh.exe --version }

# Get and extend evaluation licensing information.  Works only in local console session.
# https://sid-500.com/2017/08/08/windows-server-2016-evaluation-how-to-extend-the-trial-period/
# slmgr -dlv
# slmgr -rearm
# Restart-Computer
# slmgr -dli

Restart-Computer -ComputerName $nodes -Credential $credential -Wait -For Wmi -Force

$userName = Read-Host -Prompt "Enter User Name"
New-LocalUser -Name $userName -AccountNeverExpires -PasswordNeverExpires -UserMayNotChangePassword
Add-LocalGroupMember -Group "Administrators" -Member $userName
