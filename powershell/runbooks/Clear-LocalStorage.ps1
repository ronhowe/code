[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]
    $LogsPath = "D:\home\LogFiles\MyLogs"
)
begin {
    Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

    $ErrorActionPreference = "Stop"

    Write-Verbose "Truncating Database Table"
    Invoke-SqlCmd -ConnectionString "Server=localhost;Database=MyDatabase;Integrated Security=True;Application Name=$($MyInvocation.MyCommand.Name);Encrypt=False;Connect Timeout=1;Command Timeout=0;" -Query "TRUNCATE TABLE [MyTable];"
    
    Write-Verbose "Removing Azure Storage Table"
    New-AzStorageContext -ConnectionString "UseDevelopmentStorage=true;" |
    Get-AzStorageTable -Name "MyCloudTable" -ErrorAction SilentlyContinue |
    Remove-AzStorageTable -Name "MyCloudTable" -Force
    
    Write-Verbose "Removing Log Files"
    Get-ChildItem -Path $LogsPath -Recurse |
    Remove-Item -Force -ErrorAction Continue
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
