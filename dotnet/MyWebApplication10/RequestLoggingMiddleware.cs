namespace MyWebApplication10;

/// <summary>
/// Middleware for logging incoming HTTP requests and outgoing HTTP responses.
/// </summary>
public class RequestLoggingMiddleware(RequestDelegate next, ILogger<RequestLoggingMiddleware> logger)
{
    /// <summary>
    /// Invokes the middleware to log request and response information.
    /// </summary>
    /// <param name="context">The HTTP context for the current request.</param>
    /// <returns>A task representing the asynchronous operation.</returns>
    public async Task Invoke(HttpContext context)
    {
        logger.LogInformation("Incoming HTTP Request");
        await next(context);
        logger.LogInformation("Outgoing HTTP Response");
    }
}
