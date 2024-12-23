using Azure.Data.Tables;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Polly;

namespace MyClassLibrary;

public class MyRepository(ILogger<MyService> logger, IConfiguration configuration) : IMyRepository
{
    public async Task SaveAsync(bool myInput)
    {
        logger.LogInformation("Entering {name}", nameof(MyRepository));

        logger.LogDebug("myInput = {myInput}", myInput);

        const string _dbConnection = "MyDatabase";
        string? dbConnectionString;
        try
        {
            logger.LogInformation("Getting Database Connection String");
            dbConnectionString = configuration[$"ConnectionStrings:{_dbConnection}"];
#if DEBUG
            logger.LogDebug("dbConnectionString = {dbConnectionString}", dbConnectionString);
#endif
        }
        catch (Exception ex)
        {
            logger.LogError("Error Getting Database Connection String Because {message}", ex.Message);
            throw;
        }

        const string _azConnection = "MyAzureStorage";
        string? azConnectionString;
        try
        {
            logger.LogInformation("Getting Azure Storage Connection String");
            azConnectionString = configuration[$"ConnectionStrings:{_azConnection}"];
#if DEBUG
            logger.LogDebug("azConnectionString = {azConnectionString}", azConnectionString);
#endif
        }
        catch (Exception ex)
        {
            logger.LogError("Error Getting Azure Storage Connection String Because {message}", ex.Message);
            throw;
        }

        logger.LogInformation("Generating Row Key");
        var rowKey = Guid.CreateVersion7().ToString();

        logger.LogInformation("Saving {rowKey}", rowKey);

        // TODO: Read retry settings from configuration.
        const int _maxRetries = 2;
        const int _retryMilliseconds = 1;

        logger.LogInformation("Creating Retry Policy");
        var retryPolicy = Policy
            .Handle<SqlException>()
            .WaitAndRetryAsync(_maxRetries, retryAttempt => TimeSpan.FromMilliseconds(_retryMilliseconds),
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
            await retryPolicy.ExecuteAsync(async () =>
            {
                if (!_dbSaved)
                {
                    logger.LogInformation("Saving To Database");

                    logger.LogInformation("Opening Connection");
                    using SqlConnection connection = new(dbConnectionString);
                    await connection.OpenAsync();

                    logger.LogInformation("Executing Command");
                    using SqlCommand command = new("INSERT [dbo].[MyTable] ([PartitionKey], [RowKey], [MyInput]) VALUES (@PartitionKey, @RowKey, @MyInput);", connection);
                    command.Parameters.AddWithValue("@PartitionKey", DateTime.UtcNow);
                    command.Parameters.AddWithValue("@RowKey", rowKey);
                    command.Parameters.AddWithValue("@MyInput", myInput);
                    await command.ExecuteNonQueryAsync();
                }

                _dbSaved = true;
                logger.LogInformation("Save To Database Succeeded");

                if (!_azSaved)
                {
                    logger.LogInformation("Saving To Azure Storage");

                    logger.LogInformation("Creating Table");
                    var tableClient = new TableClient(azConnectionString, "MyCloudTable");
                    await tableClient.CreateIfNotExistsAsync();

                    logger.LogInformation("Adding Entity");
                    var tableEntity = new TableEntity(DateTime.UtcNow.ToString("yyyy-MM-dd"), rowKey)
                    {
                        { "MyInput", myInput }
                    };
                    await tableClient.AddEntityAsync(tableEntity);
                }

                _azSaved = true;
                logger.LogInformation("Save To Azure Storage Succeeded");
            });
        }
        catch (Exception ex)
        {
            logger.LogError("Save Failed Because {message}", ex.Message);
            logger.LogCritical("CRITICAL ERROR");
#if DEBUG
            throw;
#endif
        }

        logger.LogInformation("Exiting {name}", nameof(MyRepository));
    }
}
