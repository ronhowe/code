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
        logger.LogTrace("Entering {name}", nameof(MyService));

        logger.LogInformation("OK");

        logger.LogDebug("Logging Input");
        logger.LogDebug("$input = {input}", input);

        try
        {
            logger.LogTrace("Configuring Query");
            logger.LogDebug("_connectionString = {_connectionString}", _connectionString);
            logger.LogDebug("_sqlQuery = {_sqlQuery}", _sqlQuery);

            logger.LogTrace("Opening Connection");
            using SqlConnection connection = new(_connectionString);
            connection.Open();

            logger.LogTrace("Executing Query");
            using SqlCommand command = new(_sqlQuery, connection);
            command.Parameters.AddWithValue("@Value", input);
            command.ExecuteNonQuery();
        }
        catch (Microsoft.Data.SqlClient.SqlException ex)
        {
            logger.LogCritical(ex, "{Message}", ex.Message);
        }

        logger.LogTrace("Returning Result");
        bool result = input;

        logger.LogTrace("Exiting {name}", nameof(MyService));

        return result;
    }
}
