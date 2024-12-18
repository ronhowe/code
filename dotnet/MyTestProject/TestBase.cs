using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics;

namespace MyTestProject;

public class TestBase
{
    [TestCleanup]
    public void TestCleanup()
    {
        Debug.WriteLine($"Cleaning Test");
    }

    [TestInitialize]
    public void TestInitialize()
    {
        Debug.WriteLine($"/{new string('*', 79)}");
        Debug.WriteLine("https://github.com/ronhowe");
        Debug.WriteLine($"{new string('*', 79)}/");
        Debug.WriteLine($"{DateTime.Now} (LOCAL)");
        Debug.WriteLine($"{DateTime.UtcNow} (UTC)");
        Debug.WriteLine($"Initializing Test");
    }
}
