[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [ValidateNotNullorEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    $HandbrakeInputPath = "D:\OBS",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullorEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    $HandbrakeOutputPath = "D:\OBS",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullorEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    $HandbrakeCliPath = "$HOME\Downloads\HandBrakeCLI-1.9.2-win-x86_64\HandBrakeCLI.exe"
)
begin {
    Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
}
process {
    $ErrorActionPreference = "Stop"

    Write-Debug "Process $($MyInvocation.MyCommand.Name)"

    #region Validate Parameters

    if (-not (Test-Path -Path $HandbrakeInputPath)) {
        Write-Error "Could not find $HandbrakeInputPath."
    }

    if (-not (Test-Path -Path $HandbrakeOutputPath)) {
        Write-Error "Could not find $HandbrakeInputPath." -ErrorAction Stop
    }

    if (-not (Test-Path -Path $HandbrakeCliPath)) {
        Write-Error "Could not find $HandbrakeCliPath." -ErrorAction Stop
    }

    #endregion Validate Parameters

    #region Transcode with Handbrake CLI

    Write-Verbose "Transcoding with Handbrake CLI"

    Get-ChildItem -Path $HandbrakeInputPath -Filter "*.mkv" |
    ForEach-Object {
        $MkvPath = $_.FullName
        Write-Debug "`$MkvPath = $MkvPath"

        $Mp4Path = Join-Path -Path $HandbrakeOutputPath -ChildPath $($_.Name.Replace(".mkv", ".mp4"))
        Write-Debug "`$Mp4Path = $Mp4Path"

        if (-not (Test-Path -Path $Mp4Path)) {
            Write-Verbose "Starting Handbrake CLI"

            # https://handbrake.fr/docs/en/latest/cli/command-line-reference.html
            Start-Process -Path $HandbrakeCliPath -ArgumentList "--input", "`"$MkvPath`"", "--output", "`"$Mp4Path`"", "--all-audio" -Wait -NoNewWindow
        }

        ## TODO: Handle Process Return Code

        if (Test-Path -Path $Mp4Path) {
            Write-Verbose "Confirmed $Mp4Path"
        }
        else {
            Write-Error "Could not find $Mp4Path"
            Write-Error "MP4 Missing After Call To Handbrake CLI" -ErrorAction Stop
        }
    }

    #endregion Transcode with Handbrake CLI

    Write-Host "OK" -ForegroundColor Green
}
end {
    Write-Debug "End $($MyInvocation.MyCommand.Name)"
}
