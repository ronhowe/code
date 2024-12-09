/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.FeatureManagement;

namespace MyClassLibrary;

public class MyService(ILogger<MyService> logger, IConfiguration configuration, IFeatureManager featureManager) : IMyService
{
    public bool MyMethod(bool input)
    {
        logger.LogDebug("Entering {name}", nameof(MyService));

        logger.LogDebug("Logging Input");
        logger.LogTrace("input = {input}", input);

        /*******************************************************************************
        CONFIGURATIONS
        *******************************************************************************/

        string connectionString = string.Empty;
        try
        {
            logger.LogDebug("Getting Connection String");
            connectionString = configuration["ConnectionStrings:MyDatabase"] ?? string.Empty;
        }
        catch (Exception ex)
        {
            logger.LogError("Error Getting Connection String");
            logger.LogError(ex, "{Message}", ex.Message);
            throw;
        }
        finally
        {
            logger.LogTrace("connectionString = {connectionString}", connectionString);
        }

        /*******************************************************************************
        FEATURES
        *******************************************************************************/

        bool myFeature = false;
        try
        {
            logger.LogDebug("Getting MyFeature Toggle");
            myFeature = featureManager.IsEnabledAsync("MyFeature").Result;
        }
        catch (Exception ex)
        {
            logger.LogError("Error Getting MyFeature Toggle");
            logger.LogError(ex, "{Message}", ex.Message);
        }
        finally
        {
            logger.LogTrace("myFeature = {myFeature}", myFeature);
        }

        /*******************************************************************************
        SERVICES
        *******************************************************************************/

        if (myFeature)
        {
            logger.LogDebug("Featured Enabled");
            try
            {
                logger.LogDebug("Opening Connecting");
                using SqlConnection connection = new(connectionString);
                connection.Open();

                logger.LogDebug("Executing Command");
                using SqlCommand command = new("INSERT [dbo].[MyTable] ([Value]) VALUES (@Value);", connection);
                command.Parameters.AddWithValue("@Value", input);
                command.ExecuteNonQuery();
            }
            catch (Microsoft.Data.SqlClient.SqlException ex)
            {
                logger.LogCritical("Feature Failed");
                logger.LogCritical(ex, "{Message}", ex.Message);
            }
        }
        else
        {
            logger.LogWarning("Feature Not Enabled");
        }

        // important business logic =)
        bool result = input;

        logger.LogInformation("Returning {result}", result);

        logger.LogDebug("Exiting {name}", nameof(MyService));

        return result;
    }
}
