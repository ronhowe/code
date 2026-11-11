using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.FeatureManagement;

namespace MyClassLibrary10;

public class MyService(ILogger<MyService> logger, IConfiguration configuration, IFeatureManager featureManager, IMyRepository repository) : IMyService
{
    public async Task<bool> MyMethodAsync(bool myInput, CancellationToken cancellationToken = default)
    {
        if (logger.IsEnabled(LogLevel.Information))
        {
            logger.LogInformation("Entering {name}", nameof(MyService));
        }

        string? _myConfiguration;
        try
        {
            _myConfiguration = configuration["MyConfiguration"];
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Error Reading MyConfiguration");
            throw;
        }

        string? _mySecret;

        try
        {
            _mySecret = configuration["MySecret"];
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Error Reading MySecret");
            throw;
        }

        bool? _myFeature;

        try
        {
            _myFeature = await featureManager.IsEnabledAsync("MyFeature");
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Error Reading MyFeature");
            throw;
        }

        if ((bool)_myFeature)
        {
            logger.LogInformation("Saving Enabled, Persisting To Repository");
            await repository.SaveAsync(myInput, cancellationToken);
        }
        else
        {
            logger.LogInformation("Saving Disabled");
        }

        if (logger.IsEnabled(LogLevel.Information))
        {
            logger.LogInformation("Exiting {name}", nameof(MyService));
        }

        return myInput;
    }
}
