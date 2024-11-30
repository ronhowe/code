#requires -RunAsAdministrator

# Import module(s).
Import-Module -Name "Hyper-V"

# Get the operating system.
$os = Read-Host -Prompt "(L)inux or (W)indows"

# Get the ISO path.
$isoPath =
switch ($os) {
    "L" { "C:\Users\ronhowe\Downloads\LAB\ubuntu-20.04.4-live-server-amd64.iso" }
    "W" { "C:\Users\ronhowe\Downloads\LAB\Windows Server 2025.iso" }
    default { throw }
}

# Test the ISO path.
Test-Path -Path $isoPath

# Get the virtual machine name.
$nodeName = Read-Host -Prompt "Enter Virtual Machine Name"

# Get the virtual hard drive path.
$vhdPath = "D:\Hyper-V\Virtual Hard Disks\$nodeName.vhdx"

# Set the virtual switch name.
$switchName = "Internal Switch"

# Create the virtual hard disk.
New-VHD -Path $vhdPath -SizeBytes 127GB -Dynamic

# Create the virtual machine.
New-VM -Name $nodeName -MemoryStartupBytes 8GB -VHDPath $vhdPath -SwitchName $switchName -Generation 2

# Set the processor count.
Set-VM -VMName $nodeName -ProcessorCount 8

# Disable automatic checkpoints.
Set-VM -Name $nodeName -AutomaticCheckpointsEnabled $false

# Enable guest services.
Enable-VMIntegrationService -VMName $nodeName -Name "Guest Service Interface"

# Add DVD drive with mounted ISO.
Add-VMDvdDrive -VMName $nodeName -Path $isoPath

# Set device boot order.
Set-VMFirmware -VMName $nodeName -FirstBootDevice $(Get-VMDvdDrive -VMName $nodeName)

# Disable secure boot for Linux virtual machines.
# https://docs.microsoft.com/en-us/windows-server/virtualization/hyper-v/supported-ubuntu-virtual-machines-on-hyper-v
if ($os -eq "L") {
    Set-VMFirmware -VMName $nodeName -EnableSecureBoot Off
}

# Open the virtual machine console.
vmconnect.exe localhost $nodeName

# Start the virtual machine.
Start-VM -VMName $nodeName

# Complete the OOBE setup.

# Get the virtual machine.
Get-VM -VMName $nodeName

# Stop the virtual machine gracefully.
Stop-VM -VMName $nodeName

# Checkpoint the virtual machine.
Checkpoint-VM -VMName $nodeName -SnapshotName "BASE"

# Stop the virtual machine forcefully.
Stop-VM -VMName $nodeName -Force

# Remove the virtual machine.
Remove-VM -VMName $nodeName -Force

# Remove the virtual hard disk.
Remove-Item -Path $vhdPath -Force
