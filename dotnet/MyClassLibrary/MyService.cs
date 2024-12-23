using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.FeatureManagement;

namespace MyClassLibrary;

public class MyService(ILogger<MyService> logger, IConfiguration configuration, IFeatureManager featureManager, IMyRepository repository) : IMyService
{
    public async Task<bool> MyMethodAsync(bool myInput)
    {
        logger.LogInformation("Entering {name}", nameof(MyService));

        logger.LogDebug("myInput = {myInput}", myInput);

        string? myConfiguration;
        try
        {
            logger.LogInformation("Getting MyConfiguration From Configuration");
            myConfiguration = configuration["MyConfiguration"];
            logger.LogDebug("myConfiguration = {myConfiguration}", myConfiguration);
        }
        catch (Exception ex)
        {
            logger.LogError("Error Getting MyConfiguration Because {message}", ex.Message);
            throw;
        }

        string? mySecret;
        try
        {
            logger.LogInformation("Getting MySecret From Configuration");
            mySecret = configuration["MySecret"];
            logger.LogDebug("mySecret = {mySecret}", mySecret);
        }
        catch (Exception ex)
        {
            logger.LogError("Error Getting MySecret Because {message}", ex.Message);
            throw;
        }

        bool? myFeature;
        try
        {
            logger.LogInformation("Getting MyFeature From Configuration");
            myFeature = featureManager.IsEnabledAsync("MyFeature").Result;
            logger.LogDebug("myFeature = {myFeature}", myFeature);
        }
        catch (Exception ex)
        {
            logger.LogError("Error Getting MyFeature Because {message}", ex.Message);
            throw;
        }

        logger.LogInformation("Saving Input To Repository");
        await repository.SaveAsync(myInput);

        logger.LogInformation("Returning {result}", myInput);

        logger.LogInformation("Exiting {name}", nameof(MyService));

        return await Task.FromResult(myInput);
    }
}
