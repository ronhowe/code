function Remove-LastCommand {
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        Write-Verbose "Getting History Save Path"
        $filePath = (Get-PSReadLineOption).HistorySavePath
        Write-Debug "`$filePath = $filePath"

        Write-Verbose "Getting Last Command"
        $lastCommand = (Get-History -Count 1).CommandLine
        Write-Debug "`$lastCommand = $lastCommand"

        Write-Verbose "Getting Content"
        $content = Get-Content $filePath |
        Where-Object { $_ -ne $lastCommand }

        Write-Verbose "Setting Content"
        Set-Content $filePath -Value $content
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}

New-Alias -Name "redact" -Value "Remove-LastCommand" -Force -Scope Global
