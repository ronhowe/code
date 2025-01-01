throw

Import-Module -Name "Hyper-V"

$Credential = Get-Credential -Message "Enter Administrator Credential" -UserName "administrator"

$userName = $Credential.UserName

$nodes = Read-Host -Prompt "Enter Node Name"

$ipAddress = "192.168.0.3" # Standardized static IP.

$sshDestination = "$userName@$ipAddress"

ssh $sshDestination hostname

ssh -t $sshDestination "sudo apt update -y"

ssh -t $sshDestination "sudo apt upgrade -y"

## NOTE: Enable guest services.
## LINK: https://docs.microsoft.com/en-us/windows-server/virtualization/hyper-v/supported-ubuntu-virtual-machines-on-hyper-v
ssh -t $sshDestination "sudo apt-get install linux-azure -y"

ssh -t $sshDestination "sudo reboot"

ssh $sshDestination "hostnamectl"

ssh -t $sshDestination "sudo hostnamectl set-hostname $nodes"

# Regenerate SSH keys.
# These must be run locally because they terminate and eliminate SSH connectivity.
# sudo /bin/rm -v /etc/ssh/ssh_host_*
# sudo dpkg-reconfigure openssh-server
# sudo systemctl restart ssh

ssh-keygen -R $ipAddress
ssh-keygen -R $nodes

Test-NetConnection -ComputerName $ipAddress -Port 22 # ssh

Get-Content -Path "C:\Windows\System32\drivers\etc\hosts" | Select-String -SimpleMatch "LAB-LNX-00"

Test-NetConnection -ComputerName $nodes -Port 22

$sshDestination = "$userName@$nodes"

ssh $sshDestination hostname

ssh $sshDestination date

ssh $sshDestination "timedatectl"

ssh $sshDestination "timedatectl"

ssh $sshDestination "timedatectl list-timezones"

ssh $sshDestination "sudo timedatectl set-timezone Etc/UTC"
# ssh $sshDestination "sudo timedatectl set-timezone America/New_York"

## LINK: https://learn.microsoft.com/en-us/powershell/scripting/security/remoting/ssh-remoting-in-powershell?view=powershell-7.4
ssh $sshDestination

# cd /
# sudo find -name "pwsh"
# sudo nano /etc/ssh/sshd_config
# # paste
# Subsystem powershell /snap/bin/pwsh -sshs -NoLogo
# sudo systemctl restart sshd.service

$session = New-PSSession -HostName $nodes -UserName administrator

$session | Get-PSSession

$session | Enter-PSSession

$session | Remove-PSSession

# Use Secure Copy Program (scp) from WSL to copy file to the host.
scp ./OnboardingScript.sh administrator@LAB-LNX-00:/home/administrator
