using System.Diagnostics;

namespace MyTestProject10;

/// <summary>
/// Base class for all tests providing initialization and cleanup.
/// </summary>
public class TestBase
{
    /// <summary>
    /// Runs after each test method completes.
    /// </summary>
    [TestCleanup]
    public void TestCleanup()
    {
    }

    /// <summary>
    /// Runs before each test method starts.
    /// </summary>
    [TestInitialize]
    public void TestInitialize()
    {
        Debug.WriteLine($"{new string('*', 80)}");
        Debug.WriteLine("https://github.com/ronhowe");
        Debug.WriteLine($"{new string('*', 80)}");
        Debug.WriteLine($"{DateTime.UtcNow:yyyy-MM-dd HH:mm:ss.fff} (UTC)");
    }
}
