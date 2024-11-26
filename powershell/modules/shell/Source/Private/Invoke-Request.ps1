function Invoke-Request {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline)]
        [uri]$Uri,

        [Parameter()]
        [switch]$ContentOnly
    )
    begin {
        Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Debug "Process $($MyInvocation.MyCommand.Name)"

        $response = Invoke-WebRequest -Uri $Uri -UseBasicParsing

        if ($ContentOnly.IsPresent) {
            return $response.Content
        }
        else {
            return $response
        }
    }
    end {
        Write-Debug "End $($MyInvocation.MyCommand.Name)"
    }
}