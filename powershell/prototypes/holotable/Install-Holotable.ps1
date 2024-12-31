[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]
    $SourceCdfPath = "$HOME\repos\ronhowe\code\powershell\prototypes\holotable",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]
    $TargetCdfPath = $env:HOLOTABLE_PATH,

    [switch]
    $IncludeImages
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

    Write-Verbose "Copying Card Definitions"
    Copy-Item -Path (Join-Path -Path $Path -ChildPath "*.cdf") -Destination $TargetCdfPath -Force -PassThru

    ## NOTE: Only needed if file hashes are incorrect.
    Write-Verbose "Asserting Include Images Switch"
    if ($IncludeImages) {
        Write-Verbose "Copying Card Images"
        Copy-Item -Path (Join-Path -Path $Path -ChildPath "Images-HT\starwars") -Destination (Join-Path -Path $TargetCdfPath -ChildPath "cards") -Recurse -Force -PassThru
    }
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
