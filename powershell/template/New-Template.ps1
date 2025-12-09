#requires -Module "Pester"
#requires -PSEdition "Core"
#requires -RunAsAdministrator
function New-Template {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("^[a-zA-Z0-9_.-]+$")]
        [string]
        $Name,

        [Parameter(Mandatory = $false, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path -Path $_ })]
        [string]
        $Path,

        [Parameter(Mandatory = $false, Position = 2, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("VMName")]
        [ValidateNotNullorEmpty()]
        [string[]]
        $ComputerName,

        [Parameter(Mandatory = $false, Position = 3)]
        [pscredential]
        $Credential,

        [Parameter(Mandatory = $false, Position = 4)]
        [ValidateSet("OptionA", "OptionB")]
        [string]
        $Option = "OptionA"
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        Write-Verbose "Doing Something ; Please Wait"

        foreach ($computer in $ComputerName) {
            Write-Host "Doing Something On $($computer.ToUpper())" -ForegroundColor Cyan
            Write-Output $computer
        }
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
    <#
.SYNOPSIS
Creates a new template and performs actions on specified computers.

.DESCRIPTION
The `New-Template` function creates a new template and performs actions on the specified computers. 
It accepts a name, a path, a list of computer names, optional credentials, and an option parameter.

.PARAMETER Name
Specifies the name of the template. This parameter is mandatory and must be a non-empty string 
matching the pattern `^[a-zA-Z0-9_.-]+$`.

.PARAMETER Path
Specifies the path where the template will be created. This parameter is mandatory and must be a valid path.

.PARAMETER ComputerName
Specifies the names of the computers on which actions will be performed. This parameter is mandatory 
and accepts an array of strings. It can also accept input from the pipeline.

.PARAMETER Credential
Specifies the credentials to use for authentication. This parameter is optional.

.PARAMETER Option
Specifies an option for the operation. This parameter is optional and accepts one of the following values:
- OptionA (default)
- OptionB

.INPUTS
[string[]]
You can pipe an array of strings to the `ComputerName` parameter.

.OUTPUTS
[string[]]
The function outputs the names of the computers on which actions were performed.

.EXAMPLE
PS> New-Template -Name "MyTemplate" -Path "C:\Templates" -ComputerName "Server1", "Server2"

Creates a new template named "MyTemplate" at the specified path and performs actions on "Server1" and "Server2".

.EXAMPLE
PS> "Server1", "Server2" | New-Template -Name "MyTemplate" -Path "C:\Templates"

Pipes the computer names to the `New-Template` function, creating a new template and performing actions on the specified computers.

.EXAMPLE
PS> New-Template -Name "MyTemplate" -Path "C:\Templates" -ComputerName "Server1" -Option "OptionB"

Creates a new template named "MyTemplate" at the specified path and performs actions on "Server1" using "OptionB".

.LINK
http://www.fabrikam.com/extension.html
#>
}
