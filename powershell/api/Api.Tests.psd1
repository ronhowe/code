@{
    Endpoints = @(
        @{
            Enabled  = $true
            Endpoint = @{
                Name     = "MyWebApplication"
                Platform = "Kestrel"
                Uri      = "https://localhost:444"
                Header   = "MyHeader (Development)"
            }
        }
        @{
            Enabled  = $true
            Endpoint = @{
                Name     = "MyWebApplication"
                Platform = "AppService"
                Uri      = "https://app-ronhowe-0.azurewebsites.net:443"
                Header   = "MyHeader (Production)"
            }
        }
    )
}
