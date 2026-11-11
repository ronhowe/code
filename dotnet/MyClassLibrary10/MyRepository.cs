using Azure.Data.Tables;
using Azure.Identity;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Polly;

namespace MyClassLibrary10;

public class MyRepository(ILogger<MyRepository> logger, IConfiguration configuration, IHostEnvironment environment) : IMyRepository
{
    public async Task SaveAsync(bool myInput)
    {
        if (logger.IsEnabled(LogLevel.Information))
        {
            logger.LogInformation("Entering {name}", nameof(MyRepository));
        }

        const string _dbConnection = "MyDatabase";
        string _dbConnectionString;

        try
        {
            _dbConnectionString = configuration[$"ConnectionStrings:{_dbConnection}"] ?? throw new InvalidOperationException("Database Connection String Not Configured");
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Error Reading Database Connection String");
            throw;
        }

        const string _azConnection = "MyAzureStorage";
        string _azConnectionString;

        try
        {
            _azConnectionString = configuration[$"ConnectionStrings:{_azConnection}"] ?? throw new InvalidOperationException("Azure Storage Connection String Not Configured");
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Error Reading Azure Storage Connection String");
            throw;
        }

        string _rowKey = Guid.CreateVersion7().ToString();

        // TODO: Read retry settings from configuration.
        const int _maxRetries = 3;
        const int _retryMilliseconds = 1000;

        var _retryPolicy = Policy
            .Handle<SqlException>()
            .WaitAndRetryAsync(_maxRetries, retryAttempt => TimeSpan.FromMilliseconds(_retryMilliseconds),
                (ex, timeSpan, retryAttempt, context) =>
                {
                    if (logger.IsEnabled(LogLevel.Warning))
                    {
                        logger.LogWarning("Retry Attempt {retryAttempt} Of {maxRetries} After {exception}", retryAttempt, _maxRetries, ex.Message);
                    }
                });

        bool _dbSaved = false;
        bool _azSaved = false;

        try
        {
            await _retryPolicy.ExecuteAsync(async () =>
            {
                if (!_dbSaved)
                {
                    using SqlConnection _sqlConnection = new(_dbConnectionString);
                    await _sqlConnection.OpenAsync();

                    using SqlCommand _sqlCommand = new("INSERT [dbo].[MyTable] ([PartitionKey], [RowKey], [MyInput]) VALUES (@PartitionKey, @RowKey, @MyInput);", _sqlConnection);
                    _sqlCommand.Parameters.AddWithValue("@PartitionKey", DateTime.UtcNow);
                    _sqlCommand.Parameters.AddWithValue("@RowKey", _rowKey);
                    _sqlCommand.Parameters.AddWithValue("@MyInput", myInput);

                    await _sqlCommand.ExecuteNonQueryAsync();
                    _dbSaved = true;
                    logger.LogInformation("Saved To Database Successfully");
                }

                if (!_azSaved)
                {
                    TableClient _tableClient;

                    if (environment.IsDevelopment())
                    {
                        _tableClient = new(_azConnectionString, "MyCloudTable");
                    }
                    else
                    {
                        var _credential = new DefaultAzureCredential();
                        _tableClient = new TableClient(new Uri(_azConnectionString), "MyCloudTable", _credential);
                    }

                    await _tableClient.CreateIfNotExistsAsync();

                    TableEntity _tableEntity = new(DateTime.UtcNow.ToString("yyyy-MM-dd"), _rowKey)
                    {
                        { "MyInput", myInput }
                    };

                    await _tableClient.AddEntityAsync(_tableEntity);
                    _azSaved = true;
                    logger.LogInformation("Saved To Azure Storage Successfully");
                }
            });
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Error Saving Data");
            throw;
        }

        if (logger.IsEnabled(LogLevel.Information))
        {
            logger.LogInformation("Exiting {name}", nameof(MyRepository));
        }
    }
}
