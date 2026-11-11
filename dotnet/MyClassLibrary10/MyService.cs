using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.FeatureManagement;

namespace MyClassLibrary10;

/// <summary>
/// Service for processing data requests with feature management and conditional persistence.
/// </summary>
public class MyService(ILogger<MyService> logger, IConfiguration configuration, IFeatureManager featureManager, IMyRepository repository) : IMyService
{
    /// <summary>
    /// Processes the provided save request, conditionally persisting data to the repository based on feature toggle.
    /// </summary>
    /// <param name="request">The save request containing data to be processed.</param>
    /// <param name="cancellationToken">Cancellation token for the operation.</param>
    /// <returns>True if the save request was enabled and processed; otherwise false.</returns>
    /// <exception cref="InvalidOperationException">Thrown when configuration keys cannot be read.</exception>
    public async Task<bool> ProcessAsync(SaveRequest request, CancellationToken cancellationToken = default)
    {
        if (logger.IsEnabled(LogLevel.Information))
        {
            logger.LogInformation("Entering {name}", nameof(MyService));
        }

        string? _myConfiguration;
        try
        {
            _myConfiguration = configuration[AppConstants.Configuration.MyConfigurationKey];
        }
        catch (Exception ex)
        {
            if (logger.IsEnabled(LogLevel.Error))
            {
                logger.LogError(ex, "Failed To Read Configuration Key 'MyConfiguration'. Ensure The Configuration Provider Is Properly Configured And The Key Exists");
            }
            throw;
        }

        string? _mySecret;

        try
        {
            _mySecret = configuration[AppConstants.Configuration.MySecretKey];
        }
        catch (Exception ex)
        {
            if (logger.IsEnabled(LogLevel.Error))
            {
                logger.LogError(ex, "Failed To Read Configuration Key 'MySecret'. Ensure The Secret Management Provider Is Properly Configured And The Secret Exists");
            }
            throw;
        }

        bool? _myFeature;

        try
        {
            _myFeature = await featureManager.IsEnabledAsync(AppConstants.Features.MySaveFeature);
        }
        catch (Exception ex)
        {
            if (logger.IsEnabled(LogLevel.Error))
            {
                logger.LogError(ex, "Failed To Evaluate Feature Flag 'MyFeature'. Ensure FeatureManagement Is Properly Configured And The Feature Flag Exists");
            }
            throw;
        }

        if ((bool)_myFeature)
        {
            if (logger.IsEnabled(LogLevel.Information))
            {
                logger.LogInformation("Saving Enabled, Persisting To Repository");
            }
            await repository.SaveAsync(request, cancellationToken);
        }
        else
        {
            if (logger.IsEnabled(LogLevel.Information))
            {
                logger.LogInformation("Saving Disabled");
            }
        }

        if (logger.IsEnabled(LogLevel.Information))
        {
            logger.LogInformation("Exiting {name}", nameof(MyService));
        }

        return request.IsEnabled;
    }
}
