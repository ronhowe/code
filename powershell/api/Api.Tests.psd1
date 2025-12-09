@{
    Endpoints = @(
        @{
            Enabled  = $true
            Endpoint = @{
                Name     = "MyWebApplication10"
                Platform = "Kestrel"
                Uri      = "https://localhost:444"
                Header   = "MyHeader (Development)"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name     = "MyWebApplication10"
                Platform = "AppService"
                Uri      = "https://app-ronhowe-0.azurewebsites.net:443"
                Header   = "MyHeader (Production)"
            }
        }
    )
}
