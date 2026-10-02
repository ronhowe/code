Configuration GuestDscLite {
    param(
    )

    Import-DscResource -ModuleName "PSDesiredStateConfiguration" -ModuleVersion "1.1"

    Node $AllNodes.NodeName {
        Log PowerOnSelfTest {
            Message = "Power-On Self-Test $([guid]::NewGuid().ToString())"
        }
        File "CreateTestDirectory" {
            DestinationPath = "C:\test"
            Ensure          = "Present"
            Type            = "Directory"
        }

    }
}
