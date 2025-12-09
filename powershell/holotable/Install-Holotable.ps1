[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]
    $SourceCdfPath = $PSScriptRoot,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]
    $TargetCdfPath = $env:HOLOTABLE_PATH,

    [switch]
    $IncludeImages
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    $ErrorActionPreference = "Stop"

    Write-Verbose "Copying Card Definitions"
    Copy-Item -Path (Join-Path -Path $SourceCdfPath -ChildPath "*.cdf") -Destination $TargetCdfPath -Force -PassThru

    ## NOTE: Only needed if file hashes are incorrect.
    if ($IncludeImages) {
        Write-Verbose "Copying Card Images"
        Copy-Item -Path (Join-Path -Path $SourceCdfPaths -ChildPath "Images-HT\starwars") -Destination (Join-Path -Path $TargetCdfPath -ChildPath "cards") -Recurse -Force -PassThru
    }
    else {
        Write-Verbose "Skipping Card Images"
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
