/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Logging;

namespace MyClassLibrary;

public class MyService(ILogger<MyService> logger) : IMyService
{
    public bool MyMethod(bool input)
    {
        logger.LogDebug("Entering {name}", nameof(MyService));

        logger.LogDebug("Logging Input Parameter(s) and Value(s)");
        logger.LogDebug("$input = {input}", input);

        logger.LogDebug("Running Query");
        try
        {
            using SqlConnection connection = new("Application Name=MyClassLibraryTests;Server=localhost;Database=MyDatabase;Connect Timeout=1;Trusted_Connection=True;Encrypt=Optional;");
            connection.Open();
            using SqlCommand command = new("INSERT [dbo].[MyTable] ([Value]) VALUES (@Value);", connection);
            command.Parameters.AddWithValue("@Value", input);
            command.ExecuteNonQuery();
        }
        catch (Microsoft.Data.SqlClient.SqlException ex)
        {
            logger.LogCritical(ex, "{Message}", ex.Message);
            // TODO - Throw "StorageUnavailableCustomException" instead?
            throw;
        }
        finally
        {
            logger.LogDebug("Query Complete");
        }

        logger.LogDebug("Returning Result");

        bool result = input;

        logger.LogDebug("Exiting {name}", nameof(MyService));

        return result;
    }
}
