/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using System.Diagnostics;

namespace MyTestProject;

[TestClass]
public sealed class MyTest
{
    [TestMethod]
    public void POST()
    {
        Debug.WriteLine("Power-On Self-Test");
    }
}
