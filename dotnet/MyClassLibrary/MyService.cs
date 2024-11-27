/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using Microsoft.Extensions.Logging;

namespace MyClassLibrary;

public class MyService(ILogger<MyService> logger) : IMyService
{
    public bool MyMethod(bool input)
    {
        logger.LogDebug("Entering {name}", nameof(MyService));

        logger.LogDebug("Logging Input Parameter(s) and Value(s)");
        logger.LogDebug("$input = {input}", input);

        bool result = input; // very important business logic =)

        logger.LogDebug("Exiting {name}", nameof(MyService));

        return result;
    }
}
