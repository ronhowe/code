/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics;

namespace MyTestProject;

[TestClass]
public sealed class MyTest : TestBase
{
    [TestMethod]
    public void MyTestMethod()
    {
        Debug.WriteLine("Test");
    }
}
