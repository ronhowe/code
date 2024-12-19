New-Item -Path $profile -Force

'. $HOME\repos\ronhowe\code\powershell\profile.ps1' |
Set-Content -Path $profile -Force

. $profile
