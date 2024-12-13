/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using Azure.Data.Tables;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Polly;

namespace MyClassLibrary;

public class MyRepository(ILogger<MyService> logger, IConfiguration configuration) : IMyRepository
{
    public void Save(bool input)
    {
        logger.LogDebug("Entering {name}", nameof(MyRepository));

        const string _dbConnection = "MyDatabase";
        string dbConnectionString = string.Empty;
        try
        {
            logger.LogDebug("Getting Database Connection String From Configuration");
            dbConnectionString = configuration[$"ConnectionStrings:{_dbConnection}"] ?? string.Empty;
            logger.LogTrace("dbConnectionString = {dbConnectionString}", dbConnectionString);
        }
        catch (Exception ex)
        {
            logger.LogError("Error Getting Database Connection String From Configuration");
            logger.LogError(ex, "{Message}", ex.Message);
            throw;
        }

        const string _azConnection = "MyAzureStorage";
        string azConnectionString = string.Empty;
        try
        {
            logger.LogDebug("Getting Azure Storage Connection String From Configuration");
            azConnectionString = configuration[$"ConnectionStrings:{_azConnection}"] ?? string.Empty;
            logger.LogTrace("azConnectionString = {azConnectionString}", azConnectionString);
        }
        catch (Exception ex)
        {
            logger.LogError("Error Getting Azure Storage Connection String From Configuration");
            logger.LogError(ex, "{Message}", ex.Message);
            throw;
        }

        try
        {
            // TODO - read from configuration
            const int _maxRetries = 2;
            const int _retryMilliseconds = 1;

            logger.LogDebug("Creating Retry Policy Database");
            var retryPolicy = Policy
                .Handle<SqlException>()
                .WaitAndRetry(_maxRetries, retryAttempt => TimeSpan.FromMilliseconds(_retryMilliseconds),
                    (ex, timeSpan, retryAttempt, context) =>
                    {
                        logger.LogError("Save Failed Because {message}", ex.Message);
                        logger.LogWarning("Retry Attempt # {retryAttempt} Of {maxRetries}", retryAttempt, _maxRetries);
                    });

            logger.LogDebug("Executing With Retry Policy");
            retryPolicy.Execute(() =>
                {
                    logger.LogDebug("Saving Input To Database");

                    logger.LogDebug("Opening Connection");
                    using SqlConnection connection = new(dbConnectionString);
                    connection.Open();

                    logger.LogDebug("Executing Command");
                    using SqlCommand command = new("INSERT [dbo].[MyTable] ([Value]) VALUES (@Value);", connection);
                    command.Parameters.AddWithValue("@Value", input);
                    command.ExecuteNonQuery();

                    logger.LogDebug("Save To Database Succeeded");

                    logger.LogDebug("Saving Input To Azure Storage");

                    logger.LogDebug("Creating Table");
                    var tableClient = new TableClient(azConnectionString, "MyCloudTable");
                    tableClient.CreateIfNotExists();

                    // TODO - choose better rowkey
                    logger.LogDebug("Adding Entity");
                    var tableEntity = new TableEntity(DateTime.UtcNow.ToString("yyyy-MM-dd"), Guid.NewGuid().ToString())
                    {
                        { "input", input }
                    };
                    tableClient.AddEntity(tableEntity);

                    logger.LogDebug("Save To Azure Storage Succeeded");
                }
            );
        }
        catch (Exception ex)
        {
            logger.LogError("Save Failed Because {message}", ex.Message);
            logger.LogCritical("CRITICAL DATA LOSS!");
            throw;
        }

        logger.LogDebug("Exiting {name}", nameof(MyRepository));
    }
}
