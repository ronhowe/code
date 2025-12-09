#requires -Module "Pester"
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateSet("*", "MyWebApplication")]
    [string]
    $Name = "MyWebApplication",

    [Parameter(Mandatory = $false)]
    [ValidateSet("*", "AppService", "Kestrel")]
    [string]
    $Platform = "*",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullorEmpty()]
    [int]
    $Sleep = 1,

    [switch]
    $Loop,

    [switch]
    $SkipApplicationChecks,

    [switch]
    $SkipHealthChecks
)
do {
    $path = "$PSScriptRoot\Api.Tests.ps1"
    $data = (Import-PowerShellDataFile -Path "$PSScriptRoot\Api.Tests.psd1").Endpoints |
    Where-Object { ($_.Enabled -eq $true) -and ($_.Endpoint.Name -like $Name) -and ($_.Endpoint.Platform -like $Platform) } |
    Select-Object -ExpandProperty "Endpoint"
    if ($data) {
        $includeTags = @()
        $excludeTags = @()

        if ($SkipApplicationChecks) {
            Write-Warning "Skipping Application Checks"
            $excludeTags += "application"
        }

        if ($SkipHealthChecks) {
            Write-Warning "Skipping Health Checks"
            $excludeTags += "healthcheck"
        }

        Write-Verbose "Invoking Pester"
        Invoke-Pester -Path $path -Output Detailed -Container (New-PesterContainer -Path $path -Data $data) -TagFilter $includeTags -ExcludeTagFilter $excludeTags

        if ($Loop) {
            Write-Host "Sleeping $Sleep Second(s)..." -ForegroundColor Cyan
            Start-Sleep -Seconds $Sleep
        }
    }
    else {
        Write-Warning "No Test Definitions Found"
    }
}
while ($Loop)
