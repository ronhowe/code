namespace MyClassLibrary10;

/// <summary>
/// Repository for persisting save requests to database and cloud storage.
/// </summary>
public interface IMyRepository
{
    /// <summary>
    /// Saves the provided request to both database and Azure storage.
    /// </summary>
    /// <param name="request">The save request to persist.</param>
    /// <param name="cancellationToken">Cancellation token for the operation.</param>
    public Task SaveAsync(SaveRequest request, CancellationToken cancellationToken = default);
}
