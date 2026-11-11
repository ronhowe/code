namespace MyWebApplication10;

/// <summary>
/// Constants used throughout the web application.
/// </summary>
public static class WebConstants
{
    /// <summary>
    /// Authorization policy names.
    /// </summary>
    public static class Policies
    {
        /// <summary>
        /// Policy name for requiring MyClaimType claim.
        /// </summary>
        public const string MyClaimPolicy = "MyClaimPolicy";
    }

    /// <summary>
    /// HTTP header names and values.
    /// </summary>
    public static class Headers
    {
        /// <summary>
        /// Custom header key for application identification.
        /// </summary>
        public const string MyHeader = "MyHeader";
    }

    /// <summary>
    /// Logging configuration.
    /// </summary>
    public static class Logging
    {
        /// <summary>
        /// Serilog output template for console logging.
        /// </summary>
        public const string OutputTemplate = "[{UtcTimestamp:yyyy-MM-dd HH:mm:ss.fff}] [{Level:u3}] [{SourceContext}] {Message}{NewLine}{Exception}";

        /// <summary>
        /// Source context for Program.cs logging.
        /// </summary>
        public const string SourceContext = nameof(Program);
    }

    /// <summary>
    /// JWT authentication configuration.
    /// </summary>
    public static class JWT
    {
        /// <summary>
        /// Default JWT issuer.
        /// </summary>
        public const string DefaultIssuer = "myIssuer";

        /// <summary>
        /// Default JWT audience.
        /// </summary>
        public const string DefaultAudience = "myAudience";
    }

    /// <summary>
    /// Claim type and value constants.
    /// </summary>
    public static class Claims
    {
        /// <summary>
        /// Claim type for identifying the user/requestor.
        /// </summary>
        public const string MyClaimType = "MyClaimType";

        /// <summary>
        /// Expected claim value for authorization.
        /// </summary>
        public const string MyClaimValue = "MyClaimValue";
    }

    /// <summary>
    /// API route constants.
    /// </summary>
    public static class Routes
    {
        /// <summary>
        /// Health check endpoint.
        /// </summary>
        public const string HealthCheck = "/healthcheck";

        /// <summary>
        /// Error handler endpoint.
        /// </summary>
        public const string Error = "/error";
    }
}
