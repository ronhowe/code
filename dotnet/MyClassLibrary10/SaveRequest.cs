namespace MyClassLibrary10;

/// <summary>
/// Represents a data save request with semantic meaning.
/// </summary>
public class SaveRequest
{
    /// <summary>
    /// Gets a value indicating whether the data should be persisted.
    /// </summary>
    public bool IsEnabled { get; init; }

    private SaveRequest(bool isEnabled)
    {
        IsEnabled = isEnabled;
    }

    /// <summary>
    /// Creates a new save request that is enabled.
    /// </summary>
    public static SaveRequest CreateEnabled() => new(true);

    /// <summary>
    /// Creates a new save request that is disabled.
    /// </summary>
    public static SaveRequest CreateDisabled() => new(false);

    /// <summary>
    /// Creates a new save request with the specified state.
    /// </summary>
    public static SaveRequest Create(bool isEnabled) => new(isEnabled);
}
