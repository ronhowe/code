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
    private const string _connectionString = "Application Name=MyClassLibraryTests;Server=localhost;Database=MyDatabase;Connect Timeout=1;Trusted_Connection=True;Encrypt=Optional;";
    private const string _cmdText = "INSERT [dbo].[MyTable] ([Value]) VALUES (@Value);";
    private const bool _myFeature = false;

    public bool MyMethod(bool input)
    {
        logger.LogDebug("Entering {name}", nameof(MyService));

        logger.LogDebug("Logging Input");
        logger.LogTrace("input = {input}", input);

        /*******************************************************************************
        CONFIGURATIONS
        *******************************************************************************/

        string connectionString = _connectionString;
        try
        {
            logger.LogDebug("Getting Connection String");
            // todo - truly understand why this doesn't work in Moq
            // connectionString = configuration.GetConnectionString("MyDatabase") ?? _connectionString;
            connectionString = configuration["ConnectionStrings.MyDatabase"] ?? _connectionString;
        }
        catch (Exception ex)
        {
            logger.LogError("Error Getting Connection String ; Using Default");
            logger.LogError(ex, "{Message}", ex.Message);
        }
        finally
        {
            logger.LogTrace("connectionString = {connectionString}", connectionString);
        }

        string cmdText = _cmdText;
        try
        {
            logger.LogDebug("Getting Command Text");
            cmdText = configuration["MyCommand"] ?? _cmdText;
        }
        catch (Exception ex)
        {
            logger.LogError("Error Getting Command Text ; Using Default");
            logger.LogError(ex, "{Message}", ex.Message);
        }
        finally
        {
            logger.LogTrace("cmdText = {cmdText}", cmdText);
        }

        /*******************************************************************************
        FEATURES
        *******************************************************************************/

        bool myFeature = _myFeature;
        try
        {
            logger.LogDebug("Getting MyFeature Toggle");
            myFeature = featureManager.IsEnabledAsync("MyFeature").Result;
        }
        catch (Exception ex)
        {
            logger.LogError("Error Getting MyFeature Toggle ; Using Default");
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
                using SqlConnection connection = new(_connectionString);
                connection.Open();

                logger.LogDebug("Executing Command");
                using SqlCommand command = new(_cmdText, connection);
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
