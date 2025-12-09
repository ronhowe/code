$credential = Get-Credential
$computers = @("LAB-DC-00")
$computers = @("LAB-APP-00", "LAB-SQL-00", "LAB-WEB-00")
$computers = @("LAB-APP-00", "LAB-DC-00", "LAB-SQL-00", "LAB-WEB-00")
$computers = @("LAB-APP-00", "LAB-DC-00", "LAB-SQL-00", "LAB-WEB-00", "NON-EXISTENT", "LOCALHOST")
$computers = @("LAB-APP-00", "LAB-DC-00", "LAB-SQL-00", "LAB-WEB-00") * 5
$computers = @("LAB-APP-00", "LAB-DC-00", "LAB-SQL-00", "LAB-WEB-00", "NON-EXISTENT", "LOCALHOST") * 5
$thumbprint = "F59627BB6A2B553E68A5565A5DFA639CB91574DE"

#region ForEach Serial With Script Block
Measure-Command {
    $computers |
    ForEach-Object {
        $session = New-PSSession -ComputerName $_ -Credential $credential
        if ($session) {
            Invoke-Command -Session $session -ScriptBlock {
                Get-ChildItem -Path "Cert:\LocalMachine\My\$thumbprint" |
                Select-Object -First 1 |
                Select-Object -Property "Thumbprint", "NotBefore", "NotAfter", "Subject", "Issuer"
            }
            Remove-PSSession -Session $session
        }
    } |
    Select-Object -Property @(@{Name = "ComputerName"; Expression = { $_.PSComputerName } }, "Thumbprint", "NotAfter") |
    Format-Table -AutoSize
} |
Format-Table -AutoSize
#endregion ForEach Serial With Script Block

#region ForEach Serial With File
Measure-Command {
    $computers |
    ForEach-Object {
        $session = New-PSSession -ComputerName $_ -Credential $credential
        if ($session) {
            $parameters = @{
                Session      = $session
                FilePath     = "D:\repos\ronhowe\powershell\runbook\Debug-ParallelRemoteSessionScript.ps1"
                ArgumentList = @($thumbprint)
            }
            Invoke-Command @parameters
            Remove-PSSession -Session $session
        }
    } |
    Select-Object -Property @(@{Name = "ComputerName"; Expression = { $_.PSComputerName } }, "Thumbprint", "NotAfter") |
    Format-Table -AutoSize
} |
Format-Table -AutoSize
#endregion Serial With File

#region Array Of Computer Names With File
Measure-Command {
    $parameters = @{
        ComputerName = $computers
        Credential   = $credential
        FilePath     = "D:\repos\ronhowe\powershell\runbook\Debug-ParallelRemoteSessionScript.ps1"
        ArgumentList = @($thumbprint)
    }
    Invoke-Command @parameters |
    Select-Object -Property @(@{Name = "ComputerName"; Expression = { $_.PSComputerName } }, "Thumbprint", "NotAfter") |
    Format-Table -AutoSize
} |
Format-Table -AutoSize
#endregion Array Of Computer Names With File

#region ForEach Parallel With Script Block (PowerShell Core Only)
Measure-Command {
    $computers |
    ForEach-Object -Parallel {
        $thumbprint = $using:thumbprint
        $session = New-PSSession -ComputerName $_ -Credential $using:credential
        if ($session) {
            Invoke-Command -Session $session -ScriptBlock {
                Get-ChildItem -Path "Cert:\LocalMachine\My\$using:thumbprint" |
                Select-Object -Property "Thumbprint", "NotBefore", "NotAfter", "Subject", "Issuer"
            }
            Remove-PSSession -Session $session
        }
    } -ThrottleLimit 20 |
    Select-Object -Property @(@{Name = "ComputerName"; Expression = { $_.PSComputerName } }, "Thumbprint", "NotAfter") |
    Format-Table -AutoSize
} |
Format-Table -AutoSize
#endregion ForEach Parallel With Script Block (PowerShell Core Only)

#region ForEach Parallel With File (PowerShell Core Only)
Measure-Command {
    $computers |
    ForEach-Object -Parallel {
        $session = New-PSSession -ComputerName $_ -Credential $using:credential
        if ($session) {
            $parameters = @{
                Session      = $session
                FilePath     = "D:\repos\ronhowe\powershell\runbook\Debug-ParallelRemoteSessionScript.ps1"
                ArgumentList = @($using:thumbprint)
            }
            Invoke-Command @parameters
            Remove-PSSession -Session $session
        }
    } -ThrottleLimit 20 |
    Select-Object -Property @(@{Name = "ComputerName"; Expression = { $_.PSComputerName } }, "Thumbprint", "NotAfter") |
    Format-Table -AutoSize
} |
Format-Table -AutoSize
#endregion ForEach Parallel With File (PowerShell Core Only)

$computers |
ForEach-Object -Parallel {
    Write-Host "Restarting $_ ; Please Wait"
    Restart-Computer -ComputerName $_ -Credential $using:credential -Force -Wait -Verbose
} -ThrottleLimit 20
