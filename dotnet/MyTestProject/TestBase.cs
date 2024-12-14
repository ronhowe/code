/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics;

namespace MyTestProject;

public class TestBase
{
    [TestCleanup]
    public void TestCleanup()
    {
        Debug.WriteLine($"Cleaning Test");
        Debug.WriteLine($"{new string('*', 79)}/ ");
    }

    [TestInitialize]
    public void TestInitialize()
    {
        Debug.WriteLine($"/{new string('*', 79)}");
        Debug.WriteLine($"OK");
        Debug.WriteLine($"{DateTime.Now} LOCAL");
        Debug.WriteLine($"{DateTime.UtcNow} UTC");
        Debug.WriteLine($"Initializing Test");
    }
}
