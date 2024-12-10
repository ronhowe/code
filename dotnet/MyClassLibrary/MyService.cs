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

        string myMessage = string.Empty;
        try
        {
            logger.LogDebug("Getting MyMessage from Configuration");
            myMessage = configuration["MyMessage"] ?? string.Empty;
        }
        catch (Exception ex)
        {
            logger.LogError("Error Getting MyMessage from Configuration");
            logger.LogError(ex, "{Message}", ex.Message);
            throw;
        }
        finally
        {
            logger.LogTrace("myMessage = {myMessage}", myMessage);
        }

        /*******************************************************************************
        SECRETS
        *******************************************************************************/

        string mySecret = string.Empty;
        try
        {
            logger.LogDebug("Getting MySecret from Configuration");
            mySecret = configuration["MySecret"] ?? string.Empty;
        }
        catch (Exception ex)
        {
            logger.LogError("Error Getting MySecret from Configuration");
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
            logger.LogDebug("Getting MyFeature from Configuration");
            myFeature = featureManager.IsEnabledAsync("MyFeature").Result;
        }
        catch (Exception ex)
        {
            logger.LogError("Error Getting MyFeature from Configuration");
            logger.LogError(ex, "{Message}", ex.Message);
        }
        finally
        {
            logger.LogTrace("myFeature = {myFeature}", myFeature);
        }

        if (myFeature)
        {
            logger.LogDebug("MyFeature Enabled");

            /*******************************************************************************
            REPOSITORY
            *******************************************************************************/

            repository.Save(input);
        }
        else
        {
            logger.LogWarning("Feature Not Enabled");
        }

        /*******************************************************************************
        APPLICATION
        *******************************************************************************/

        // important business logic =)
        bool result = input;

        logger.LogInformation("Returning {result}", result);

        logger.LogDebug("Exiting {name}", nameof(MyService));

        return result;
    }
}
