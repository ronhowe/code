throw

Import-Module -Name "Microsoft.PowerShell.SecretManagement"
Import-Module -Name "Microsoft.PowerShell.SecretStore"

Reset-SecretStore -PassThru -Force

Get-SecretVault | Unregister-SecretVault
Register-SecretVault -Name "my-secret-vault" -ModuleName "Microsoft.PowerShell.SecretStore" -DefaultVault

Set-Secret -Name "Mock Secret" -Secret "Mock Password" -Metadata @{ Description = "A Mock Secret" }
Get-Secret -Name "Mock Secret" -AsPlainText

Set-Secret -Name "Administrator" -Secret $(Get-Credential -Message "Enter Administrator Credential" -UserName "Administrator") -Metadata @{ Description = "Administrator Credential" }
Get-Secret -Name "Administrator"

Get-SecretInfo | Select-Object -Property *

(Read-Host -Prompt "Enter Comma Separated Node Names") -split "," |
Get-HostByName |
# Select-Object -Property @{Name = "ComputerName"; Expression = { $_ } } |
ForEach-Object {
    Invoke-Command -ComputerName $_ -Credential $(Get-Secret -Name "Administrator") -ScriptBlock { $env:COMPUTERNAME }
}
