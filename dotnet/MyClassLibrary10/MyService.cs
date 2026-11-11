using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.FeatureManagement;

namespace MyClassLibrary10;

public class MyService(ILogger<MyService> logger, IConfiguration configuration, IFeatureManager featureManager, IMyRepository repository) : IMyService
{
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
            logger.LogError(ex, "Failed To Read Configuration Key 'MyConfiguration'. Ensure The Configuration Provider Is Properly Configured And The Key Exists");
            throw;
        }

        string? _mySecret;

        try
        {
            _mySecret = configuration[AppConstants.Configuration.MySecretKey];
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Failed To Read Configuration Key 'MySecret'. Ensure The Secret Management Provider Is Properly Configured And The Secret Exists");
            throw;
        }

        bool? _myFeature;

        try
        {
            _myFeature = await featureManager.IsEnabledAsync(AppConstants.Features.MySaveFeature);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Failed To Evaluate Feature Flag 'MyFeature'. Ensure FeatureManagement Is Properly Configured And The Feature Flag Exists");
            throw;
        }

        if ((bool)_myFeature)
        {
            logger.LogInformation("Saving Enabled, Persisting To Repository");
            await repository.SaveAsync(request, cancellationToken);
        }
        else
        {
            logger.LogInformation("Saving Disabled");
        }

        if (logger.IsEnabled(LogLevel.Information))
        {
            logger.LogInformation("Exiting {name}", nameof(MyService));
        }

        return request.IsEnabled;
    }
}
