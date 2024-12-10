# Turn off progress bar.
$ProgressPreference = "SilentlyContinue"

# Import module(s).
Import-Module -Name "Hyper-V"

# Get the administrator credential.
$credential = Get-Credential -Message "Enter Administrator Credential" -UserName "Administrator"

# Get the host name.
$nodeName = Read-Host -Prompt "Enter Node Name"

# Get the VM.
Get-VM -Name $nodeName

# Get the host name.
Invoke-Command -VMName $nodeName -Credential $credential -ScriptBlock { hostname }

# Set the host name.
Invoke-Command -VMName $nodeName -Credential $credential -ScriptBlock { Rename-Computer -NewName $using:nodeName -Restart -Force }

# Test Internet connectivity.
$scriptBlock = {
    $ProgressPreference = "SilentlyContinue"
    Test-NetConnection
}
Invoke-Command -VMName $nodeName -Credential $credential -ScriptBlock $scriptBlock

# Get the virtual machine IP addresses.
$LABDC01 = "192.168.0.10" ; $LABDC01 ; $ipAddress = $LABDC01
$LABAPP01 = "192.168.0.20" ; $LABAPP01 ; $ipAddress = $LABAPP01
$LABSQL01 = "192.168.0.30" ; $LABSQL01 ; $ipAddress = $LABSQL01
$LABWEB01 = "192.168.0.40" ; $LABWEB01 ; $ipAddress = $LABWEB01
# or
$DOMAIN01 = "192.168.0.197" ; $DOMAIN01 ; $ipAddress = $DOMAIN01
$DOMAIN02 = "192.168.0.198" ; $DOMAIN02 ; $ipAddress = $DOMAIN02
$DOMAIN41 = "192.168.0.129" ; $DOMAIN41 ; $ipAddress = $DOMAIN41
$DOMAIN42 = "192.168.0.130" ; $DOMAIN42 ; $ipAddress = $DOMAIN42
# or
$ipAddress = Read-Host -Prompt "Enter IP address"

# Get the gateway IP address.
$GATEWAY = "192.168.0.1" ; $GATEWAY ; $gatewayIpAddress = $GATEWAY
# ro
$gatewayIpAddress = Read-Host -Prompt "Enter gateway IP address"

# Get the router IP address.
$ROUTER = "192.168.1.1" ; $ROUTER ; $routerIpAddress = $ROUTER
# or
$routerIpAddress = Read-Host -Prompt "Enter router IP address"

# Get the DNS IP addresses.
$PRIMARY = $LABDC01 ; $PRIMARY ; $primaryDnsIpAddress = $PRIMARY
$SECONDARY = $routerIpAddress; $SECONDARY ; $secondaryDnsIpAddress = $SECONDARY
# or
$PRIMARY = $DOMAIN01 ; $PRIMARY ; $primaryDnsIpAddress = $PRIMARY
$SECONDARY = $routerIpAddress; $SECONDARY ; $secondaryDnsIpAddress = $SECONDARY
# or
$primaryDnsIpAddress = Read-Host -Prompt "Enter primary DNS IP address"
$secondaryDnsIpAddress = Read-Host -Prompt "Enter secondary DNS IP address"

# Set a static IP address.
$scriptBlock = {
    $ProgressPreference = "SilentlyContinue"
    $interfaceIndex = $(Get-NetAdapter -Name "Ethernet").ifIndex
    Remove-NetIPAddress -InterfaceIndex $interfaceIndex -Confirm:$false
    Remove-NetRoute -InterfaceIndex $interfaceIndex -Confirm:$false
    New-NetIPAddress -IPAddress $using:IpAddress -AddressFamily IPv4 -PrefixLength "24" -InterfaceIndex $interfaceIndex -DefaultGateway $using:gatewayIpAddress
    Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses ($using:primaryDnsIpAddress, $using:secondaryDnsIpAddress)
}
Invoke-Command -VMName $nodeName -Credential $credential -ScriptBlock $scriptBlock

# Test WinRM to the host.
Test-NetConnection -ComputerName $nodeName -Port 5985 -WarningAction SilentlyContinue

# Create a PowerShell session over WinRM.
$session = New-PSSession -ComputerName $nodeName -Credential $credential

# Check the session.
$session | Get-PSSession

# Enter the session.
$session | Enter-PSSession

# Close the session.
$session | Remove-PSSession

# Get Windows Firewall for PING (ICMP).
$scriptBlock = {
    $ProgressPreference = "SilentlyContinue"
    Get-NetFirewallRule -DisplayName "Allow inbound ICMPv4"
    Get-NetFirewallRule -DisplayName "Allow inbound ICMPv6"
}
Invoke-Command -ComputerName $nodeName -Credential $credential -ScriptBlock $scriptBlock

# Set Windows Firewall to allow inbound PING (ICMP).
$scriptBlock = {
    $ProgressPreference = "SilentlyContinue"
    New-NetFirewallRule -DisplayName "Allow inbound ICMPv4" -Direction Inbound -Protocol ICMPv4 -IcmpType 8 -Action Allow
    New-NetFirewallRule -DisplayName "Allow inbound ICMPv6" -Direction Inbound -Protocol ICMPv6 -IcmpType 8 -Action Allow
}
Invoke-Command -ComputerName $nodeName -Credential $credential -ScriptBlock $scriptBlock

# PING the host.
Test-NetConnection -ComputerName $nodeName -WarningAction SilentlyContinue

# Get timezone.
$scriptBlock = {
    Get-TimeZone
}
Invoke-Command -ComputerName $nodeName -Credential $credential -ScriptBlock $scriptBlock

# Set timezone.
$scriptBlock = {
    Set-TimeZone -Name "Coordinated Universal Time"
    # Set-TimeZone -Name "Eastern Standard Time"
}
Invoke-Command -ComputerName $nodeName -Credential $credential -ScriptBlock $scriptBlock

# Download PowerShell Core.
$scriptBlock = {
    $ProgressPreference = "SilentlyContinue"
    Import-Module -Name "BitsTransfer"
    $source = "https://github.com/PowerShell/PowerShell/releases/download/v7.4.6/PowerShell-7.4.6-win-x64.msi"
    $destination = "~\Downloads\PowerShell-7.4.6-win-x64.msi"
    Start-BitsTransfer -Source $source -Destination $destination -Verbose
}
Invoke-Command -ComputerName $nodeName -Credential $credential -ScriptBlock $scriptBlock

# Install PowerShell Core.  This will terminate the session.
$scriptBlock = {
    Set-Location -Path "~\Downloads"
    msiexec.exe /package PowerShell-7.4.6-win-x64.msi /quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1 USE_MU=1 ENABLE_MU=1
}
Invoke-Command -ComputerName $nodeName -Credential $credential -ScriptBlock $scriptBlock

# Check for PowerShell Core.
Invoke-Command -ComputerName $nodeName -Credential $credential -ScriptBlock { pwsh.exe --version }

# Get and extend evaluation licensing information.  Works only in local console session.
# https://sid-500.com/2017/08/08/windows-server-2016-evaluation-how-to-extend-the-trial-period/
# slmgr -dlv
# slmgr -rearm
# Restart-Computer
# slmgr -dli

# Reboot the host.
Restart-Computer -ComputerName $nodeName -Credential $credential -Wait -For Wmi -Force
