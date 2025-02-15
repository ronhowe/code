[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]
    $Path,

    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [ValidateNotNullorEmpty()]
    [string[]]
    $ComputerName,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [pscredential]
    $Credential
)
begin {
    Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

    ## NOTE: Consider moving this to begin {} when appropriate to avoid multiple imports?
    Write-Verbose "Importing Some Module"
    Import-Module -Name "SomeModule" -Verbose:$false 4>&1 |
    Out-Null

    foreach ($computer in $ComputerName) {
        Write-Verbose "Doing Something To $computer"
        ## TODO: Do Something

        Write-Verbose "Splatting Something On $computer"
        $parameters = @{
            Message = "Splat Something"
        }
        Write-Verbose @parameters
    }
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
