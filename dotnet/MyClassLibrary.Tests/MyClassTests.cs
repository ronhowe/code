using System.Diagnostics;

namespace MyClassLibrary.Tests;

[TestClass]
public sealed class MyClassTests
{
    [TestMethod]
    public void POST()
    {
        Debug.WriteLine("Power-On Self-Test");
    }
}
