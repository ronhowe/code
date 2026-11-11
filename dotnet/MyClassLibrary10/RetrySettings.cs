namespace MyClassLibrary10;

public class RetrySettings
{
    public int MaxRetries { get; set; } = 3;
    public int RetryMilliseconds { get; set; } = 1000;
}
