Configuration DevBoxConfiguration {
    param(
        [string]
        $ReposPath = "$HOME\repos"
    )

    # https://learn.microsoft.com/en-us/powershell/module/psdesiredstateconfiguration/?view=dsc-1.1
    Import-DscResource -ModuleName "PSDesiredStateConfiguration"

    Node "localhost" {
        # https://learn.microsoft.com/en-us/powershell/dsc/reference/resources/windows/logresource?view=dsc-1.1
        Log PowerOnSelfTest {
            Message = "Power-On Self-Test"
        }
        
        # https://learn.microsoft.com/en-us/powershell/dsc/reference/resources/windows/fileresource?view=dsc-1.1
        File ReposFolder {
            DestinationPath = $ReposPath
            Ensure          = "Present"
            Type            = "Directory"
        }
    }
}