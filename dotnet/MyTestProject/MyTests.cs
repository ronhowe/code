using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics;
using System.Security.Cryptography;

namespace MyTestProject;

[TestClass]
[TestCategory("DebugTest")]
public sealed class MyTests : TestBase
{
    [TestMethod]
    public void MyTest()
    {
        Debug.WriteLine("Debugging");

#if DEBUG
        Debug.WriteLine("Defining DEBUG");
#endif

        Debug.WriteLine($"Creating Globally Unique Identifier");
        Debug.WriteLine(Guid.CreateVersion7());

        Debug.WriteLine($"Generating Random Number");
        var key = new byte[4096 / 8];
        RandomNumberGenerator.Fill(key);
        var base64Key = Convert.ToBase64String(key);
        Debug.WriteLine(base64Key);
    }
}
