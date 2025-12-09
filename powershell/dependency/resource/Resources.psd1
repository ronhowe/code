@{
    Resources = @(
        # Sync with GuestDsc.ps1 and Install-GuestDscResources.ps1.
        @{ Name = 'ActiveDirectoryCSDsc' ; Version = '5.0.0' ; Repository = 'PSGallery' },
        @{ Name = 'ActiveDirectoryDsc' ; Version = '6.7.0' ; Repository = 'PSGallery' },
        @{ Name = 'ComputerManagementDsc' ; Version = '10.0.0' ; Repository = 'PSGallery' },
        @{ Name = 'NetworkingDsc' ; Version = '9.1.0' ; Repository = 'PSGallery' },
        @{ Name = 'SecurityPolicyDsc' ; Version = '2.10.0.0' ; Repository = 'PSGallery' },
        @{ Name = 'SqlServerDsc' ; Version = '17.2.0' ; Repository = 'PSGallery' },
        @{ Name = 'xHyper-V' ; Version = '3.18.0' ; Repository = 'PSGallery' }
    )
}
