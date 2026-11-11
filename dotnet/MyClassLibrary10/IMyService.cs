namespace MyClassLibrary10;

/// <summary>
/// Service for handling data processing with feature management.
/// </summary>
public interface IMyService
{
    /// <summary>
    /// Processes the provided save request, conditionally persisting data based on feature toggle.
    /// </summary>
    /// <param name="request">The save request to process.</param>
    /// <param name="cancellationToken">Cancellation token for the operation.</param>
    /// <returns>True if the save request was enabled and processed; otherwise false.</returns>
    public Task<bool> ProcessAsync(SaveRequest request, CancellationToken cancellationToken = default);
}
