/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.FeatureManagement;

namespace MyClassLibrary;

public class MyService(ILogger<MyService> logger, IConfiguration configuration, IFeatureManager featureManager, IMyRepository repository) : IMyService
{
    public bool MyMethod(bool myInput)
    {
        logger.LogDebug("Entering {name}", nameof(MyService));

        logger.LogTrace("myInput = {myInput}", myInput);

        string? myConfiguration;
        try
        {
            logger.LogDebug("Getting MyConfiguration");
            myConfiguration = configuration["MyConfiguration"];
            logger.LogTrace("myConfiguration = {myConfiguration}", myConfiguration);
        }
        catch (Exception ex)
        {
            logger.LogError("Error Getting MyConfiguration");
            logger.LogError(ex, "{Message}", ex.Message);
            throw;
        }

        string? mySecret;
        try
        {
            logger.LogDebug("Getting MySecret From Configuration");
            mySecret = configuration["MySecret"];
            logger.LogTrace("mySecret = {mySecret}", mySecret);
        }
        catch (Exception ex)
        {
            logger.LogError("Error Getting MySecret From Configuration");
            logger.LogError(ex, "{Message}", ex.Message);
            throw;
        }

        bool? myFeature;
        try
        {
            logger.LogDebug("Getting MyFeature");
            myFeature = featureManager.IsEnabledAsync("MyFeature").Result;
            logger.LogTrace("myFeature = {myFeature}", myFeature);
        }
        catch (Exception ex)
        {
            logger.LogError("Error Getting MyFeature");
            logger.LogError(ex, "{Message}", ex.Message);
            throw;
        }

        logger.LogInformation("Saving Input To Repository");
        repository.Save(myInput);

        logger.LogInformation("Returning {result}", myInput);

        logger.LogDebug("Exiting {name}", nameof(MyService));

        return myInput;
    }
}
