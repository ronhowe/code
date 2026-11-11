namespace MyTestProject10;

/// <summary>
/// Constants used throughout the test suite.
/// </summary>
internal static class TestConstants
{
    /// <summary>
    /// Configuration constants.
    /// </summary>
    public static class Configuration
    {
        public const string AzureStorageConnectionString = "UseDevelopmentStorage=true;";
        public const string DatabaseConnectionString = "Server=localhost;Database=MyDatabase;Integrated Security=True;Application Name=MyTestProject;Encrypt=False;Connect Timeout=1;Command Timeout=0;";
        public const string MyConfiguration = "MyTestProject";
        public const string MyHeader = "MyHeader";
        public const string MySecret = "MyTestProject";
    }

    /// <summary>
    /// Retry policy constants.
    /// </summary>
    public static class Retry
    {
        public const int MaxRetries = 3;
        public const int RetryMilliseconds = 1000;
    }

    /// <summary>
    /// Web host constants.
    /// </summary>
    public static class WebHost
    {
        public const int HttpsPort = 5001;
        public const string BaseAddress = "https://localhost:5001";
        public const int CancellationTimeoutSeconds = 5;
    }

    /// <summary>
    /// JWT token constants.
    /// </summary>
    public static class JWT
    {
        public const string ClaimType = "MyClaimType";
        public const string ClaimValue = "MyClaimValue";
        public const string Issuer = "myIssuer";
        public const string Audience = "myAudience";
        public const int TokenExpirationMinutes = 30;
    }
}
