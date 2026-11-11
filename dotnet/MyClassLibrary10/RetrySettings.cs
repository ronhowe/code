namespace MyClassLibrary10;

/// <summary>
/// Configuration settings for retry policies used in data persistence operations.
/// </summary>
public class RetrySettings
{
    /// <summary>
    /// Gets or sets the maximum number of retry attempts for failed database operations.
    /// </summary>
    /// <value>The maximum number of retries. Default is 3.</value>
    public int MaxRetries { get; set; } = 3;

    /// <summary>
    /// Gets or sets the delay in milliseconds between retry attempts.
    /// </summary>
    /// <value>The delay in milliseconds between retry attempts. Default is 1000.</value>
    public int RetryMilliseconds { get; set; } = 1000;
}
