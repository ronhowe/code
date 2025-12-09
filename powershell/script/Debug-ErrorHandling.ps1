function Debug-ErrorHandling {
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

        #region 1
        Write-Host "Item 1" -ForegroundColor Green
        Get-Item -Path "1"
        #endregion 1
        #region 2
        try {
            Write-Host "Item 2 Try" -ForegroundColor Green
            Get-Item -Path "2"
        }
        catch {
            Write-Host "Item 2 Catch"
            Write-Error "Item 2 Catch"
        }
        finally {
            Write-Host "Item 2 Finally"
        }
        #endregion 2
        #region 3
        try {
            Write-Host "Item 3 Try" -ForegroundColor Green
            Get-Item -Path "3" -ErrorAction Stop
        }
        catch {
            Write-Host "Item 3 Catch"
            Write-Error "Item 3 Catch"
        }
        finally {
            Write-Host "Item 3 Finally"
        }
        #endregion 3
        #region 4
        try {
            Write-Host "Item 4 Try" -ForegroundColor Green
            Get-Item -Path "4" -ErrorAction Stop
        }
        catch {
            Write-Host "Item 4 Catch"
            throw $_
        }
        finally {
            Write-Host "Item 4 Finally"
        }
        #endregion 4
        #region 5
        try {
            Write-Host "Item 5 Try" -ForegroundColor Green
            Get-Item -Path "5" -ErrorAction Stop
        }
        catch {
            Write-Host "Item 5 Catch"
            Write-Error $_
            return
        }
        finally {
            Write-Host "Item 5 Finally"
        }
        #endregion 5
        Write-Host "Done"
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
Clear-Host
Wait-Debugger
Debug-ErrorHandling
