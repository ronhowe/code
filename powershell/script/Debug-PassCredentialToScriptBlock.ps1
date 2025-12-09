$scriptBlock1 = {
    param(
        [ValidateNotNullorEmpty()]
        [string]$UserName,

        [ValidateNotNullorEmpty()]
        [securestring]$Password
    )
    Write-Host $UserName
    Write-Host $Password
}

$scriptBlock2 = {
    param(
        [ValidateNotNullorEmpty()]
        [pscredential]$Credential
    )
    Write-Host $Credential.UserName
    Write-Host $Credential.Password
}

$credential = Get-Credential
Invoke-Command -ComputerName "localhost" -Credential $credential -ScriptBlock $scriptBlock1 -ArgumentList @($credential.UserName, $credential.Password)
Invoke-Command -ComputerName "localhost" -Credential $credential -ScriptBlock $scriptBlock2 -ArgumentList $credential
# EDIT
