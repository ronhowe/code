/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

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
        // LINK: MyLink
        // NOTE: MyNote
        // TODO: MyToDo
        Debug.WriteLine("Debugging");
        Debug.WriteLine(Guid.CreateVersion7());
#if DEBUG
        Debug.WriteLine("DEBUG Defined");
#endif
        // NOTE: 4096-bit key = 512 bytes
        var key = new byte[512];
        RandomNumberGenerator.Fill(key);
        var base64Key = Convert.ToBase64String(key);
        Debug.WriteLine($"Randomly Generated 4096-bit Base 64 Key:\n{base64Key}");
    }
}
