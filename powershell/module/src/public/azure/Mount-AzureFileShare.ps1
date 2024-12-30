function Mount-AzureFileShare {
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [string]
        $ResourceGroupName = $ShellConfig.ResourceGroupName,

        [ValidateNotNullOrEmpty()]
        [string]
        $StorageAccountName = $ShellConfig.StorageAccountName,

        [ValidateNotNullOrEmpty()]
        [string]
        $FileShareName = $ShellConfig.FileShareName
    )
    begin {
        Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

        Write-Verbose "Getting Azure Storage Account Key"
        $storageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $ResourceGroupName -Name $StorageAccountName)[0].Value

        Write-Verbose "Mounting Azure File Share"
        $parameters = @{
            Name       = "Z"
            PSProvider = "FileSystem"
            Root       = "\\$StorageAccountName.file.core.windows.net\$FileShareName"
            Persist    = $true
            Credential = (New-Object System.Management.Automation.PSCredential("Azure\$StorageAccountName", (ConvertTo-SecureString $storageAccountKey -AsPlainText -Force)))
        }
        New-PSDrive @parameters
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
