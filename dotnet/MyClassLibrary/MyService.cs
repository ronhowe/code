/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Logging;

namespace MyClassLibrary;

public class MyService(ILogger<MyService> logger) : IMyService
{
    private const string _connectionString = "Application Name=MyClassLibraryTests;Server=localhost;Database=MyDatabase;Connect Timeout=1;Trusted_Connection=True;Encrypt=Optional;";
    private const string _sqlQuery = "INSERT [dbo].[MyTable] ([Value]) VALUES (@Value);";

    public bool MyMethod(bool input)
    {
        logger.LogDebug("Entering {name}", nameof(MyService));

        logger.LogDebug("Logging Input");
        logger.LogTrace("input = {input}", input);

        try
        {
            logger.LogDebug("Connecting Query");
            logger.LogTrace("_connectionString = {_connectionString}", _connectionString);
            using SqlConnection connection = new(_connectionString);
            connection.Open();

            logger.LogDebug("Executing Query");
            logger.LogTrace("_sqlQuery = {_sqlQuery}", _sqlQuery);
            using SqlCommand command = new(_sqlQuery, connection);
            command.Parameters.AddWithValue("@Value", input);
            command.ExecuteNonQuery();
        }
        catch (Microsoft.Data.SqlClient.SqlException ex)
        {
            logger.LogCritical(ex, "{Message}", ex.Message);
        }

        // important business logic =)
        bool result = input;

        logger.LogInformation("Returning {result}", result);


        logger.LogDebug("Exiting {name}", nameof(MyService));

        return result;
    }
}
