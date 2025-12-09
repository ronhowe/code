throw

Import-Module -Name "Hyper-V"

$os = Read-Host -Prompt "(L)inux or (W)indows"

$isoPath =
switch ($os) {
    "L" { "C:\Users\ronhowe\Downloads\LAB\ubuntu-20.04.4-live-server-amd64.iso" }
    "W" { "C:\Users\ronhowe\Downloads\LAB\Windows Server 2025.iso" }
    default { throw }
}

Test-Path -Path $isoPath

$nodes = Read-Host -Prompt "Enter Node Name"

$vhdPath = "D:\Hyper-V\Virtual Hard Disks\$nodes.vhdx"

$switchName = "Internal Switch"

New-VHD -Path $vhdPath -SizeBytes 127GB -Dynamic

New-VM -Name $nodes -MemoryStartupBytes 8GB -VHDPath $vhdPath -SwitchName $switchName -Generation 2

Set-VM -VMName $nodes -ProcessorCount 8

Set-VM -Name $nodes -AutomaticCheckpointsEnabled $false

Enable-VMIntegrationService -VMName $nodes -Name "Guest Service Interface"

Add-VMDvdDrive -VMName $nodes -Path $isoPath

Set-VMFirmware -VMName $nodes -FirstBootDevice $(Get-VMDvdDrive -VMName $nodes)

# Disable secure boot for Linux virtual machines.
# https://docs.microsoft.com/en-us/windows-server/virtualization/hyper-v/supported-ubuntu-virtual-machines-on-hyper-v
if ($os -eq "L") {
    Set-VMFirmware -VMName $nodes -EnableSecureBoot Off
}

vmconnect.exe localhost $nodes

Start-VM -VMName $nodes

# Complete the OOBE setup.

Get-VM -VMName $nodes

Stop-VM -VMName $nodes

Checkpoint-VM -VMName $nodes -SnapshotName "BASE"

Remove-VM -VMName $nodes -Force

Remove-Item -Path $vhdPath -Force
