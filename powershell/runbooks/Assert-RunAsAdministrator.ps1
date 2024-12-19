$identity = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent())

if (-not $identity.IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    throw [System.UnauthorizedAccessException] "Not Running As Administrator"
}
