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
    public void Save(bool myInput)
    {
        logger.LogDebug("Entering {name}", nameof(MyRepository));

        logger.LogTrace("myInput = {myInput}", myInput);

        const string _dbConnection = "MyDatabase";
        string? dbConnectionString;
        try
        {
            logger.LogDebug("Getting Database Connection String");
            dbConnectionString = configuration[$"ConnectionStrings:{_dbConnection}"];
            logger.LogTrace("dbConnectionString = {dbConnectionString}", dbConnectionString);
        }
        catch (Exception ex)
        {
            logger.LogError("Error Getting Database Connection String");
            logger.LogError(ex, "{Message}", ex.Message);
            throw;
        }

        const string _azConnection = "MyAzureStorage";
        string? azConnectionString;
        try
        {
            logger.LogDebug("Getting Azure Storage Connection String");
            azConnectionString = configuration[$"ConnectionStrings:{_azConnection}"];
            logger.LogTrace("azConnectionString = {azConnectionString}", azConnectionString);
        }
        catch (Exception ex)
        {
            logger.LogError("Error Getting Azure Storage Connection String");
            logger.LogError(ex, "{Message}", ex.Message);
            throw;
        }

        logger.LogDebug("Generating Row Key");
        var rowKey = Guid.CreateVersion7().ToString();

        logger.LogInformation("Saving {rowKey}", rowKey);

        // TODO: Read from configuration.
        const int _maxRetries = 2;
        const int _retryMilliseconds = 1;

        logger.LogDebug("Creating Retry Policy");
        var retryPolicy = Policy
            .Handle<SqlException>()
            .WaitAndRetry(_maxRetries, retryAttempt => TimeSpan.FromMilliseconds(_retryMilliseconds),
                (ex, timeSpan, retryAttempt, context) =>
                {
                    logger.LogError("Save Failed Because {message}", ex.Message);
                    logger.LogWarning("Retry Attempt # {retryAttempt} Of {maxRetries}", retryAttempt, _maxRetries);
                });

        bool _dbSaved = false;
        bool _azSaved = false;

        try
        {
            logger.LogDebug("Executing With Retry Policy");
            // TODO: Fix redundant saves on retry with _dbUnsaved and _azUnsaved checks.
            retryPolicy.Execute(() =>
            {
                if (!_dbSaved)
                {
                    logger.LogDebug("Saving To Database");

                    logger.LogDebug("Opening Connection");
                    using SqlConnection connection = new(dbConnectionString);
                    connection.Open();

                    logger.LogDebug("Executing Command");
                    using SqlCommand command = new("INSERT [dbo].[MyTable] ([RowKey], [MyInput]) VALUES (@RowKey, @MyInput);", connection);
                    command.Parameters.AddWithValue("@RowKey", rowKey);
                    command.Parameters.AddWithValue("@MyInput", myInput);
                    command.ExecuteNonQuery();
                }

                _dbSaved = true;
                logger.LogDebug("Save To Database Succeeded");

                if (!_azSaved)
                {
                    logger.LogDebug("Saving To Azure Storage");

                    logger.LogDebug("Creating Table");
                    var tableClient = new TableClient(azConnectionString, "MyCloudTable");
                    tableClient.CreateIfNotExists();

                    logger.LogDebug("Adding Entity");
                    var tableEntity = new TableEntity(DateTime.UtcNow.ToString("yyyy-MM-dd"), rowKey)
                    {
                        { "MyInput", myInput }
                    };
                    tableClient.AddEntity(tableEntity);
                }

                _azSaved = true;
                logger.LogDebug("Save To Azure Storage Succeeded");
            }
            );
        }
        catch (Exception ex)
        {
            logger.LogError("Save Failed Because {message}", ex.Message);
            logger.LogCritical("CRITICAL ERROR");
            throw;
        }

        logger.LogDebug("Exiting {name}", nameof(MyRepository));
    }
}
