throw

Get-Module -Name "Shell"
Assert-RunAsAdministrator
Assert-RunAsWindowsPowerShell
Set-LocationCode

Find-Module -Name "PSWindowsUpdate" -Repository "PSGallery"

## NOTE: Last checked as of 2025-01-02.
# Version    Name                                Repository           Description
# -------    ----                                ----------           -----------
# 2.2.1.5    PSWindowsUpdate                     PSGallery            This module contain cmdlets to manage Windows Update Client.

Install-Module -Name "PSWindowsUpdate" -Repository "PSGallery" -Force
Import-Module -Name "PSWindowsUpdate"
Get-WindowsUpdate -Install -AcceptAll -AutoReboot -Verbose

Get-Command -Module "PSWindowsUpdate"

Get-WindowsUpdate -Verbose
