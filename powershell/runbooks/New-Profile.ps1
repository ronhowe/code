[CmdletBinding()]
param()

New-Item -Path $profile -Force -Verbose

@"
# autogenerated
. "$HOME\repos\ronhowe\code\powershell\profile.ps1"
"@ |
Set-Content -Path $profile -Force -Verbose

. $profile