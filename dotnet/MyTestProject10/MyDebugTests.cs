using System.Diagnostics;
using System.Management.Automation;
using System.Security.Cryptography;

namespace MyTestProject10;

[TestClass]
public sealed class MyDebugTests : TestBase
{
    [TestMethod]
    [TestCategory("DebugTest")]
    public void MyDebugTest()
    {
        Debug.WriteLine("Debugging");

        Debug.WriteLine($"Current Directory: {Environment.CurrentDirectory}");

        //Environment.GetEnvironmentVariable("PATH")?.Split(';').ToList().ForEach(p => Debug.WriteLine(p));

        var path = @"D:\repos\ronhowe\swccg-card-json\Dark.json";
        Debug.WriteLine(path);

#if DEBUG
        Debug.WriteLine("Defining DEBUG");
#endif

        Debug.WriteLine("Creating Globally Unique Identifier");
        Debug.WriteLine(Guid.CreateVersion7());

        Debug.WriteLine("Generating 4096-bit Random Key");
        byte[] buffer = new byte[4096 / 8];
        RandomNumberGenerator.Fill(buffer);
        string key = Convert.ToBase64String(buffer);
        Debug.WriteLine(key);

        Debug.WriteLine("Running PowerShell Script");
        using PowerShell ps = PowerShell.Create();

        ps.AddScript("$DebugPreference = 'Continue';");
        ps.AddScript("$ErrorPreference = 'Continue';");
        ps.AddScript("$InformationPreference = 'Continue';");
        ps.AddScript("$VerbosePreference = 'Continue';");
        ps.AddScript("$WarningPreference = 'Continue';");
        ps.AddScript("Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process;");
        ps.AddScript(@"D:\repos\ronhowe\code\powershell\script\Debug-AzureAutomationRunbook.ps1");

        var results = ps.Invoke();

        // Write-Output
        foreach (var result in results)
        {
            if (result != null)
            {
                Debug.WriteLine(result);
            }
        }

        // Write-Host & Write-Information
        foreach (var information in ps.Streams.Information)
        {
            Debug.WriteLine($"Information: {information}");
        }

        // Write-Error
        foreach (var error in ps.Streams.Error)
        {
            Debug.WriteLine($"Error: {error}");
        }

        // Write-Warning
        foreach (var warning in ps.Streams.Warning)
        {
            Debug.WriteLine($"Warning: {warning}");
        }

        // Write-Verbose
        foreach (var verbose in ps.Streams.Verbose)
        {
            Debug.WriteLine($"Verbose: {verbose}");
        }

        // Write-Debug
        foreach (var debug in ps.Streams.Debug)
        {
            Debug.WriteLine($"Debug: {debug}");
        }
    }
}
