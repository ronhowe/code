Configuration DevBoxDsc {
    param(
    )

    # https://learn.microsoft.com/en-us/powershell/module/psdesiredstateconfiguration/?view=dsc-1.1
    Import-DscResource -ModuleName "PSDesiredStateConfiguration" -ModuleVersion "1.1"

    Node "localhost" {
        # https://learn.microsoft.com/en-us/powershell/dsc/reference/resources/windows/logresource?view=dsc-1.1
        Log "PowerOnSelfTest" {
            Message = "Power-On Self-Test"
        }
        
        # https://learn.microsoft.com/en-us/powershell/dsc/reference/resources/windows/fileresource?view=dsc-1.1
        File "ReposFolder" {
            DestinationPath = Resolve-Path -Path ($Node.ReposPath)
            Ensure          = "Present"
            Type            = "Directory"
        }
    }
}
