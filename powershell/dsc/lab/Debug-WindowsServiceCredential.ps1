# $computers |
# ForEach-Object -Parallel {
#     $session = New-PSSession -ComputerName $_ -Credential $using:credential
#     if ($session) {
#         $parameters = @{
#             Session      = $session
#             FilePath     = "D:\repos\ronhowe\powershell\dsc\lab\Set-WindowsServiceCredential.ps1"
#             ArgumentList = @("MSSQLSERVER", $using:sqlCredential)
#         }
#         Invoke-Command @parameters
#         Remove-PSSession -Session $session
#     }
# } -ThrottleLimit 20

$computers |
ForEach-Object {
    $session = New-PSSession -ComputerName $_ -Credential $credential
    if ($session) {
        $parameters = @{
            Session      = $session
            FilePath     = "D:\repos\ronhowe\powershell\dsc\lab\Set-WindowsServiceCredential.ps1"
            ArgumentList = @("MSSQLSERVER", $sqlCredential)
        }
        Invoke-Command @parameters
        Remove-PSSession -Session $session
    }
}
