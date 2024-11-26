#Region '.\Private\Invoke-Request.ps1' -1

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
#EndRegion '.\Private\Invoke-Request.ps1' 33
#Region '.\Public\Aliases.ps1' -1

# sync with Aliases.ps1
# sync with Aliases.Tests.ps1
# sync with Show-Help.ps1
New-Alias -Name "catfact" -Value "Get-CatFact" -Force -Scope Global
New-Alias -Name "date" -Value "Show-Date" -Force -Scope Global
New-Alias -Name "help" -Value "Show-help" -Force -Scope Global
New-Alias -Name "logo" -Value "Show-Logo" -Force -Scope Global
New-Alias -Name "quote" -Value "Get-Quote" -Force -Scope Global
New-Alias -Name "ready" -Value "Show-Ready" -Force -Scope Global
New-Alias -Name "pshell" -Value "Start-Shell" -Scope Global -Force
New-Alias -Name "version" -Value "Show-Version" -Force -Scope Global
New-Alias -Name "weather" -Value "Get-Weather" -Force -Scope Global
#EndRegion '.\Public\Aliases.ps1' 13
#Region '.\Public\Application\Get-CatFact.ps1' -1

function Get-CatFact {
    [CmdletBinding()]
    param (
    )
    begin {
        Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
    }
    process {
        Write-Debug "Process $($MyInvocation.MyCommand.Name)"

        $result = Invoke-Request -Uri "https://catfact.ninja/fact" -ContentOnly |
        ConvertFrom-Json

        return $result.fact
    }
    end {
        Write-Debug "End $($MyInvocation.MyCommand.Name)"
    }
}
#EndRegion '.\Public\Application\Get-CatFact.ps1' 24
#Region '.\Public\Application\Get-Quote.ps1' -1

function Get-Quote {
    [CmdletBinding()]
    param (
    )
    begin {
        Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
    }
    process {
        $ProgressPreference = "SilentlyContinue"

        Write-Debug "Process $($MyInvocation.MyCommand.Name)"

        $quotes = Invoke-Request -Uri "https://type.fit/api/quotes" -ContentOnly |
        ConvertFrom-Json

        $random = Get-Random -Minimum 0 -Maximum $quotes.Count

        return $quotes[$random]
    }
    end {
        Write-Debug "End $($MyInvocation.MyCommand.Name)"
    }
}
#EndRegion '.\Public\Application\Get-Quote.ps1' 28
#Region '.\Public\Application\Get-Weather.ps1' -1

function Get-Weather {
    [CmdletBinding()]
    param (
    )
    begin {
        Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
    }
    process {
        $ProgressPreference = "SilentlyContinue"

        Write-Debug "Process $($MyInvocation.MyCommand.Name)"

        Invoke-Request -Uri "https://wttr.in/" -ContentOnly
    }
    end {
        Write-Debug "End $($MyInvocation.MyCommand.Name)"
    }
}
#EndRegion '.\Public\Application\Get-Weather.ps1' 23
#Region '.\Public\Configuration\Import-PowerConfiguration.ps1' -1

# function Import-PowerConfiguration {
#     [CmdletBinding()]
#     param (
#         [Parameter(Mandatory = $true)]
#         [ValidateNotNullOrEmpty()]
#         [string]$Name,

#         [Parameter(Mandatory = $false)]
#         [ValidateNotNullOrEmpty()]
#         [ValidateScript({ Test-Path -Path $_ })]
#         [string]$Path
#     )
#     begin {
#         Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

#         Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
#         Select-Object -Property @("Name", "Value") |
#         ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
#     }
#     process {
#         Write-Debug "Process$($MyInvocation.MyCommand.Name)"

#         try {
#             Write-Verbose "Newing PowerConfig"
#             $powerConfig = New-PowerConfig

#             Write-Verbose "Adding Module PowerConfig Json Source"
#             $powerConfig |
#             Add-PowerConfigJsonSource -Path "$PSScriptRoot\$Name.json"
#             Out-Null

#             Write-Verbose "TestingHomePowerConfigJsonSource"
#             if (Test-Path -Path "~\$Name.json") {
#                 Write-Verbose "AddingHomePowerConfigJsonSource"
#                 #
#                 $powerConfig |
#                 Add-PowerConfigJsonSource -Path $Path |
#                 Out-Null
#             }

#             Write-Verbose "TestingCustomPowerConfigJsonSource"
#             if (Test-Path -Path "$Path\$Name.json") {
#                 Write-Verbose "AddingCustomPowerConfigJsonSource"

#                 $powerConfig |
#                 Add-PowerConfigJsonSource -Path "$Path\$Name.json" |
#                 Out-Null
#             }
#             Write-Verbose "GettingPowerConfig"

#             $value = $powerConfig |
#             Get-PowerConfig

#             Write-Verbose "NewingConfigurationGlobalVariable"

#             New-Variable -Name "$Name`Configuration" -Value $value -Force -Scope Script

#             return $value
#         }
#         catch {
#             Write-Error $_
#         }
#     }
#     end {
#         Write-Debug "End $($MyInvocation.MyCommand.Name)"
#     }
# }
#EndRegion '.\Public\Configuration\Import-PowerConfiguration.ps1' 68
#Region '.\Public\Configuration\New-PowerConfiguration.ps1' -1

# function Import-PowerConfiguration {
#     [CmdletBinding()]
#     param (
#         [Parameter(Mandatory = $true)]
#         [ValidateNotNullOrEmpty()]
#         [string]$Name,

#         [Parameter(Mandatory = $false)]
#         [ValidateNotNullOrEmpty()]
#         [ValidateScript({ Test-Path -Path $_ })]
#         [string]$Path,

#         [Parameter()]
#         [switch]$Force
#     )
#     begin {
#         Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

#         Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
#         Select-Object -Property @("Name", "Value") |
#         ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
#     }
#     process {
#         Write-Debug "Process $($MyInvocation.MyCommand.Name)"

#         if ($Path) {
#             $destination = $Path
#         }
#         else {
#             $destination = "~\$Name.json"
#         }
#         Write-Debug "`$destination=$destination"

#         Write-Verbose "Copying PowerConfig Json Source"
#         Copy-Item -Path "$PSScriptRoot\$Name.json" -Destination $destination -Force:$Force

#         Write-Verbose "Importing PowerConfig Json Source"
#         Import-PowerConfiguration -Name $Name -Path $destination
#     }
#     end {
#         Write-Debug "End $($MyInvocation.MyCommand.Name)"
#     }
# }
#EndRegion '.\Public\Configuration\New-PowerConfiguration.ps1' 44
#Region '.\Public\Host\Get-Version.ps1' -1

function Get-Version {
    [CmdletBinding()]
    param (
    )
    begin {
        Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
    }
    process {
        Write-Debug "Process $($MyInvocation.MyCommand.Name)"

        return (Get-Module -Name "Shell").Version.ToString()
    }
    end {
        Write-Debug "End $($MyInvocation.MyCommand.Name)"
    }
}
#EndRegion '.\Public\Host\Get-Version.ps1' 21
#Region '.\Public\Host\Show-Date.ps1' -1

function Show-Date {
    [CmdletBinding()]
    param (
    )
    begin {
        Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
    }
    process {
        Write-Debug "Process $($MyInvocation.MyCommand.Name)"

        Write-Host $(Get-Date -AsUTC)
    }
    end {
        Write-Debug "End $($MyInvocation.MyCommand.Name)"
    }
}
#EndRegion '.\Public\Host\Show-Date.ps1' 21
#Region '.\Public\Host\Show-Help.ps1' -1

function Show-Help {
    [CmdletBinding()]
    param (
    )
    begin {
        Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
    }
    process {
        Write-Debug "Process $($MyInvocation.MyCommand.Name)"
 
        # sync with Aliases.ps1
        # sync with Aliases.Tests.ps1
        # sync with Show-Help.ps1
        Write-Host "catfact" -ForegroundColor Green
        Write-Host "date" -ForegroundColor Green
        Write-Host "help" -ForegroundColor Green
        Write-Host "logo" -ForegroundColor Green
        Write-Host "pshell" -ForegroundColor Green
        Write-Host "quote" -ForegroundColor Green
        Write-Host "ready" -ForegroundColor Green
        Write-Host "version" -ForegroundColor Green
        Write-Host "weather" -ForegroundColor Green
    }
    end {
        Write-Debug "End $($MyInvocation.MyCommand.Name)"
    }
}
#EndRegion '.\Public\Host\Show-Help.ps1' 32
#Region '.\Public\Host\Show-Logo.ps1' -1

function Show-Logo {
    [CmdletBinding()]
    param (
    )
    begin {
        Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
    }
    process {
        Write-Debug "Process $($MyInvocation.MyCommand.Name)"

        Write-Host "r" -BackgroundColor Red -ForegroundColor Black -NoNewline
        Write-Host "o" -BackgroundColor DarkYellow -ForegroundColor Black -NoNewline
        Write-Host "n" -BackgroundColor Yellow -ForegroundColor Black -NoNewline
        Write-Host "h" -BackgroundColor Green -ForegroundColor Black -NoNewline
        Write-Host "o" -BackgroundColor DarkBlue -ForegroundColor Black -NoNewline
        Write-Host "w" -BackgroundColor Blue -ForegroundColor Black -NoNewline
        Write-Host "e" -BackgroundColor Cyan -ForegroundColor Black -NoNewline
        Write-Host ".net"
    }
    end {
        Write-Debug "End $($MyInvocation.MyCommand.Name)"
    }
}
#EndRegion '.\Public\Host\Show-Logo.ps1' 28
#Region '.\Public\Host\Show-Ready.ps1' -1

function Show-Ready {
    [CmdletBinding()]
    param (
    )
    begin {
        Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
    }
    process {
        Write-Debug "Process $($MyInvocation.MyCommand.Name)"
 
        Write-Host "READY" -ForegroundColor Green
     }
    end {
        Write-Debug "End $($MyInvocation.MyCommand.Name)"
    }
}
#EndRegion '.\Public\Host\Show-Ready.ps1' 21
#Region '.\Public\Host\Show-Version.ps1' -1

function Show-Version {
    [CmdletBinding()]
    param (
    )
    begin {
        Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
    }
    process {
        Write-Debug "Process $($MyInvocation.MyCommand.Name)"

        Write-Host $(Get-Version) -ForegroundColor DarkGray
    }
    end {
        Write-Debug "End $($MyInvocation.MyCommand.Name)"
    }
}
#EndRegion '.\Public\Host\Show-Version.ps1' 21
#Region '.\Public\Host\Start-Shell.ps1' -1

function Start-Shell {
    [CmdletBinding()]
    param (
    )
    begin {
        Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
    }
    process {
        Write-Debug "Process $($MyInvocation.MyCommand.Name)"

        try {
            # Write-Verbose "Importing Power Configuration"

            # https://github.com/JustinGrote/PowerConfig/issues/7
            # Import-PowerConfiguration -Name "Shell" -Path "$PSScriptRoot\Shell.json" |
            # Out-Null

            # Write-Verbose "Showing Configuration"

            # $ShellConfiguration |
            # Format-Table -AutoSize

            Write-Verbose "Starting Shell"
            Clear-Host
            # module fails with a Sort command on Linux
            if ($PSVersionTable.Platform -ne "Unix") {
                Write-Ascii "pshell" -ForegroundColor Green
            }
            else {
                Write-Host "pshell" -ForegroundColor Green
            }
            Show-Logo
            Show-Version
            Show-Date
            Show-Ready
            Set-Location -Path $HOME
            if ($PSVersionTable.Platform -ne "Unix") {
                [System.Console]::Beep(500, 100)
            }
        }
        catch {
            Write-Error "Starting Shell Failed"
        }
    }
    end {
        Write-Debug "End $($MyInvocation.MyCommand.Name)"
    }
}
#EndRegion '.\Public\Host\Start-Shell.ps1' 53
#Region '.\Public\Protect-WithUserKey.ps1' -1

# https://devblogs.microsoft.com/powershell-community/encrypting-secrets-locally/
Function Protect-WithUserKey {
    param(
        [Parameter(Mandatory = $true)]
        [string]$secret
    )
    Add-Type -AssemblyName System.Security
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($secret)
    $SecureStr = [Security.Cryptography.ProtectedData]::Protect(
        $bytes, # contains data to encrypt
        $null, # optional data to increase entropy
        [Security.Cryptography.DataProtectionScope]::CurrentUser # scope of the encryption
    )
    $SecureStrBase64 = [System.Convert]::ToBase64String($SecureStr)
    return $SecureStrBase64
}
#EndRegion '.\Public\Protect-WithUserKey.ps1' 17
#Region '.\Public\Unprotect-WithUserKey.ps1' -1

# https://devblogs.microsoft.com/powershell-community/encrypting-secrets-locally/
Function Unprotect-WithUserKey {
    param (
        [Parameter(Mandatory = $true)]
        [string]$enc_secret
    )
    Add-Type -AssemblyName System.Security
    $SecureStr = [System.Convert]::FromBase64String($enc_secret)
    $bytes = [Security.Cryptography.ProtectedData]::Unprotect(
        $SecureStr, # bytes to decrypt
        $null, # optional entropy data
        [Security.Cryptography.DataProtectionScope]::CurrentUser) # scope of the decryption
    $secret = [System.Text.Encoding]::Unicode.GetString($bytes)
    return $secret
}
#EndRegion '.\Public\Unprotect-WithUserKey.ps1' 16
