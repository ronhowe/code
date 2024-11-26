/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using Microsoft.Extensions.Logging;

namespace MyClassLibrary;

public class MyClass(ILogger<MyClass> logger) : IMyInterface
{
    public bool MyMethod(bool input)
    {
        logger.LogDebug("Entering {name}", nameof(MyClass));

        logger.LogDebug("Logging Input Parameter(s) and Value(s)");
        logger.LogDebug("$input = {input}", input);

        bool result = input; // very important business logic =)

        logger.LogDebug("Exiting {name}", nameof(MyClass));

        return result;
    }
}
