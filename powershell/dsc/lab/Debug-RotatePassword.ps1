param(
    [PSCredential]
    $Administrator,

    [string[]]
    $Nodes = @("LAB-APP-00", "LAB-SQL-00", "LAB-WEB-00"),

    [string[]]
    $ServiceName,

    [pscredential]
    $Credential
)

Invoke-Command -ComputerName $Nodes -Credential $Administrator -ScriptBlock {
    param(
        [string[]]
        $ServiceName,

        [string]
        $UserName,

        # intentionally not a secure string due to cross server encryption boundaries
        [string]
        $Password
    )

    foreach ($service in $ServiceName) {
        Write-Host "[$env:COMPUTERNAME] Updating Service $service ; Identity $UserName"

        $s = Get-WmiObject -Class Win32_Service -Filter "Name='$service'"

        if ($null -eq $s) {
            Write-Warning "[$env:COMPUTERNAME] Service $service Not Found" -WarningAction Continue
            continue
        }

        try {
            $s.Change(
                $null, $null, $null, $null, $null, $null,
                $UserName,
                $Password
            ) |
            Out-Null

            Write-Host "[$env:COMPUTERNAME] Service $service ; Identity $UserName ; Password Updated"
        }
        catch {
            Write-Error "[$env:COMPUTERNAME] Service $service ; Identity $UserName ; Update Failed Because $_"
        }
    }
} -ArgumentList @($ServiceName, $Credential.UserName, $Credential.GetNetworkCredential().Password)
