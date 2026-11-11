using Azure.Data.Tables;
using Azure.Identity;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Polly;

namespace MyClassLibrary10;

public class MyRepository(ILogger<MyRepository> logger, IConfiguration configuration, IHostEnvironment environment, IOptions<RetrySettings> retryOptions) : IMyRepository
{
    public async Task SaveAsync(SaveRequest request, CancellationToken cancellationToken = default)
    {
        if (logger.IsEnabled(LogLevel.Information))
        {
            logger.LogInformation("Entering {name}", nameof(MyRepository));
        }

        string _dbConnectionString;

        try
        {
            _dbConnectionString = configuration[AppConstants.Configuration.DbConnectionKey] ?? throw new InvalidOperationException("Database Connection String Not Configured");
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Failed To Read Database Connection String 'ConnectionStrings:MyDatabase'. Ensure The Configuration Provider Includes Valid Connection Strings");
            throw;
        }

        string _azConnectionString;

        try
        {
            _azConnectionString = configuration[AppConstants.Configuration.AzureConnectionKey] ?? throw new InvalidOperationException("Azure Storage Connection String Not Configured");
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Failed To Read Azure Storage Connection String 'ConnectionStrings:MyAzureStorage'. Ensure The Configuration Provider Includes Valid Connection Strings For Azure");
            throw;
        }

        string _rowKey = Guid.CreateVersion7().ToString();

        var _retryPolicy = Policy
            .Handle<SqlException>()
            .WaitAndRetryAsync(retryOptions.Value.MaxRetries, retryAttempt => TimeSpan.FromMilliseconds(retryOptions.Value.RetryMilliseconds),
                (ex, timeSpan, retryAttempt, context) =>
                {
                    if (logger.IsEnabled(LogLevel.Warning))
                    {
                        logger.LogWarning("Retry Attempt {retryAttempt} Of {maxRetries} After {exception}", retryAttempt, retryOptions.Value.MaxRetries, ex.Message);
                    }
                });

        bool _dbSaved = false;
        bool _azSaved = false;

        try
        {
            await _retryPolicy.ExecuteAsync(async (ct) =>
            {
                if (!_dbSaved)
                {
                    using SqlConnection _sqlConnection = new(_dbConnectionString);
                    await _sqlConnection.OpenAsync(ct);

                    string _formattedPartitionKey = DateTime.UtcNow.ToString(AppConstants.Database.PartitionKeyDateFormat);
                    using SqlCommand _sqlCommand = new(AppConstants.Database.InsertStatement, _sqlConnection);
                    _sqlCommand.Parameters.AddWithValue($"@{AppConstants.Database.PartitionKeyColumn}", _formattedPartitionKey);
                    _sqlCommand.Parameters.AddWithValue($"@{AppConstants.Database.RowKeyColumn}", _rowKey);
                    _sqlCommand.Parameters.AddWithValue($"@{AppConstants.Database.DataColumn}", request.IsEnabled);

                    await _sqlCommand.ExecuteNonQueryAsync(ct);
                    _dbSaved = true;
                    logger.LogInformation("Saved To Database Successfully");
                }

                if (!_azSaved)
                {
                    TableClient _tableClient;

                    if (environment.IsDevelopment())
                    {
                        _tableClient = new(_azConnectionString, AppConstants.AzureTable.TableName);
                    }
                    else
                    {
                        var _credential = new DefaultAzureCredential();
                        _tableClient = new TableClient(new Uri(_azConnectionString), AppConstants.AzureTable.TableName, _credential);
                    }

                    await _tableClient.CreateIfNotExistsAsync(ct);

                    string _formattedPartitionKeyForAzure = DateTime.UtcNow.ToString(AppConstants.Database.PartitionKeyDateFormat);
                    TableEntity _tableEntity = new(_formattedPartitionKeyForAzure, _rowKey)
                    {
                        { AppConstants.Database.DataColumn, request.IsEnabled }
                    };

                    await _tableClient.AddEntityAsync(_tableEntity, ct);
                    _azSaved = true;
                    logger.LogInformation("Saved To Azure Storage Successfully");
                }
            }, cancellationToken);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Failed To Persist Data To Database And/Or Azure Storage. Check Database Connectivity, Azure Credentials, And Table/Entity Configurations. RowKey={rowKey}, RequestValue={requestValue}", _rowKey, request.IsEnabled);
            throw;
        }

        if (logger.IsEnabled(LogLevel.Information))
        {
            logger.LogInformation("Exiting {name}", nameof(MyRepository));
        }
    }
}
