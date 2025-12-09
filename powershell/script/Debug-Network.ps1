throw

Import-Module -Name "Hyper-V"

## LINK: https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/user-guide/setup-nat-network#create-a-nat-virtual-network

$switchName = "Internal Switch"

$natName = "Internal NAT"

$natGatewayIpAddress = "192.168.0.1"

New-VMSwitch -SwitchName $switchName -SwitchType Internal

Get-VMSwitch -Name $switchName | Select-Object -Property "*"

$interfaceIndex = $(Get-NetAdapter -Name "vEthernet ($switchName)").ifIndex
New-NetIPAddress -IPAddress $natGatewayIpAddress -PrefixLength 24 -InterfaceIndex $interfaceIndex

Get-NetIPAddress -IPAddress $natGatewayIpAddress

New-NetNat -Name $natName -InternalIPInterfaceAddressPrefix 192.168.0.0/24

Get-NetNat -Name $natName

Get-NetIPConfiguration | Sort-Object -Property "InterfaceAlias" | Format-Table -AutoSize

Get-NetAdapter | Sort-Object -Property "Name"

Get-NetIPAddress -AddressFamily  IPV4 | Sort-Object -Property "IPAddress" | Format-Table -AutoSize

Get-NetNat | Sort-Object -Property "Name"

Remove-NetNat -Name $natName -Confirm:$false

Remove-NetIPAddress -IPAddress $natGatewayIpAddress -Confirm:$false

Remove-VMSwitch -Name $switchName -Force
