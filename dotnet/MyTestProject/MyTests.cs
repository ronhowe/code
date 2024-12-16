/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics;

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
    }
}
