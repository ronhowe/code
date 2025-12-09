function Add-Extension {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("^[a-zA-Z0-9_.-]+$")]
        [string]
        $Name,

        [Parameter(Mandatory = $false, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Extension = "txt"
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        return $Name + "." + $Extension
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
    <#
.SYNOPSIS

Adds a file name extension to a supplied name.

.DESCRIPTION

Adds a file name extension to a supplied name.
Takes any strings for the file name or extension.

.PARAMETER Name

Specifies the file name.

.PARAMETER Extension

Specifies the extension. "Txt" is the default.

.INPUTS

None. You can't pipe objects to Add-Extension.

.OUTPUTS

System.String. Add-Extension returns a string with the extension
or file name.

.EXAMPLE

PS> Add-Extension -Name "File"
File.txt

.EXAMPLE

PS> Add-Extension -Name "File" -Extension "doc"
File.doc

.EXAMPLE

PS> Add-Extension "File" "doc"
File.doc

.LINK

http://www.fabrikam.com/extension.html

.LINK

Set-Item
#>
}
