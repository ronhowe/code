[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = "$PSScriptRoot\..\..\..\Source\Module.psd1"
)
Describe "Testing Get-Quote" {
    BeforeAll {
        Write-Verbose "Importing Configuration"
        . "$PSScriptRoot\..\..\..\Import-Configuration.ps1"
    
        Import-Module -Name "$modulePath\$moduleName" -Force

        Mock -ModuleName $moduleName Invoke-Request { return "[{'text':'mocktext','author':'mockauthor'}]" }
    }
    It "Returns Quote Text" {
        (Get-Quote).text |
        Should -Be "mocktext"
    }
    It "Returns Quote Author" {
        (Get-Quote).author |
        Should -Be "mockauthor"
    }
}
