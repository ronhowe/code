/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace MyClassLibrary;

public class MyRepository(ILogger<MyService> logger, IConfiguration configuration) : IMyRepository
{
    public void Save(bool input)
    {
        logger.LogDebug("Entering {name}", nameof(MyRepository));

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

        logger.LogDebug("Exiting {name}", nameof(MyRepository));
    }
}
