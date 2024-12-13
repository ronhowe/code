/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.FeatureManagement;

namespace MyClassLibrary;

public class MyService(ILogger<MyService> logger, IConfiguration configuration, IFeatureManager featureManager, IMyRepository repository) : IMyService
{
    public bool MyMethod(bool input)
    {
        logger.LogDebug("Entering {name}", nameof(MyService));

        logger.LogTrace("input = {input}", input);

        /*******************************************************************************
        CONFIGURATION
        *******************************************************************************/

        string myConfiguration = string.Empty;
        try
        {
            logger.LogDebug("Getting MyConfiguration From Configuration");
            myConfiguration = configuration["MyConfiguration"] ?? string.Empty;
        }
        catch (Exception ex)
        {
            logger.LogError("Error Getting MyConfiguration From Configuration");
            logger.LogError(ex, "{Message}", ex.Message);
            throw;
        }
        finally
        {
            logger.LogTrace("myConfiguration = {myConfiguration}", myConfiguration);
        }

        /*******************************************************************************
        SECRETS
        *******************************************************************************/

        string mySecret = string.Empty;
        try
        {
            logger.LogDebug("Getting MySecret From Configuration");
            mySecret = configuration["MySecret"] ?? string.Empty;
        }
        catch (Exception ex)
        {
            logger.LogError("Error Getting MySecret From Configuration");
            logger.LogError(ex, "{Message}", ex.Message);
            throw;
        }
        finally
        {
            logger.LogTrace("mySecret = {mySecret}", mySecret);
        }

        /*******************************************************************************
        FEATURE MANAGER
        *******************************************************************************/

        bool myFeature = false;
        try
        {
            logger.LogDebug("Getting MyFeature From Configuration");
            myFeature = featureManager.IsEnabledAsync("MyFeature").Result;
        }
        catch (Exception ex)
        {
            logger.LogError("Error Getting MyFeature From Configuration");
            logger.LogError(ex, "{Message}", ex.Message);
        }
        finally
        {
            logger.LogTrace("myFeature = {myFeature}", myFeature);
        }

        if (myFeature)
        {
            logger.LogDebug("MyFeature Enabled");
        }
        else
        {
            logger.LogWarning("Feature Disabled");
        }

        /*******************************************************************************
        REPOSITORY
        *******************************************************************************/

        repository.Save(input);

        logger.LogInformation("Returning {result}", input);

        logger.LogDebug("Exiting {name}", nameof(MyService));

        return input;
    }
}
