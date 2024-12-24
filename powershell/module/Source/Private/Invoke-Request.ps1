function Invoke-Request {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline)]
        [uri]
        $Uri,

        [Parameter()]
        [switch]
        $ContentOnly
    )
    begin {
        Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

        $response = Invoke-WebRequest -Uri $Uri -UseBasicParsing

        if ($ContentOnly.IsPresent) {
            return $response.Content
        }
        else {
            return $response
        }
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
