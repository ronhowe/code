Configuration GuestDscLite {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName "PSDesiredStateConfiguration" -ModuleVersion "1.1"

    ################################################################################
    #region AllNodes
    ################################################################################

    Node $AllNodes.NodeName {
        Log PowerOnSelfTest {
            Message = "Power-On Self-Test $([guid]::NewGuid().ToString())"
        }
    }

    ################################################################################
    #endregion AllNodes
    ################################################################################
}
