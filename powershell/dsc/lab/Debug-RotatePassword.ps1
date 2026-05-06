$nodes = @("LAB-APP-00", "LAB-SQL-00", "LAB-WEB-00")

$identity = "LAB\sql-service"

$password = Read-Host -Prompt "Enter Password" -MaskInput

$serviceName = "MSSQLSERVER"
# $serviceName = @("MSSQLSERVER", "SQLAgent")

foreach ($node in $nodes) {
    Invoke-Command -ComputerName $node -ScriptBlock {
        param(
            [string]
            $ServiceName,

            [string]
            $Identity,

            # Intentionally not a secure string to avoid the complexity
            # of converting to and from a secure string locally and remotely.
            # Risk is mitigated by the call being made by WinRM + HTTPS.
            [string]
            $Password
        )

        $service = Get-WmiObject -Class Win32_Service -Filter "Name='$ServiceName'"
        $result = $service.Change(
            $null, $null, $null, $null, $null, $null,
            $Identity,
            $Password
        )

        if ($result -eq 0) {
            Write-Host "[$env:COMPUTERNAME] Service $($service.Name) ; Identity $Identity ; Password Updated"
        } else {
            Write-Host "[$env:COMPUTERNAME] Service $($service.Name) ; Identity $Identity ; Update Failed Because $result"
        }
    } -ArgumentList $serviceName, $identity, $password
}
