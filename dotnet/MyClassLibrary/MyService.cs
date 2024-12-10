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

        string message = string.Empty;
        try
        {
            logger.LogDebug("Getting MyMessage from Configuration");
            message = configuration["MyMessage"] ?? string.Empty;
        }
        catch (Exception ex)
        {
            logger.LogError("Error Getting MyMessage from Configuration");
            logger.LogError(ex, "{Message}", ex.Message);
            throw;
        }
        finally
        {
            logger.LogTrace("message = {message}", message);
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
            logger.LogDebug("Featured Enabled");

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
