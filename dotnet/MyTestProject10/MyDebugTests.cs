using System.Diagnostics;
using System.Management.Automation;
using System.Security.Cryptography;

namespace MyTestProject10;

/// <summary>
/// Debug tests for environment and system inspection.
/// </summary>
[TestClass]
public sealed class MyDebugTests : TestBase
{
    /// <summary>
    /// Base debug test method (no-op).
    /// </summary>
    [TestMethod]
    [TestCategory("DebugTest")]
    public void DebugBase()
    {
    }

    /// <summary>
    /// Tests DEBUG preprocessor directive.
    /// </summary>
    [TestMethod]
    [TestCategory("DebugTest")]
    public void DebugDirective()
    {
#if DEBUG
        Debug.WriteLine("Defining DEBUG");
#endif
    }

    /// <summary>
    /// Inspects current environment and PATH variables.
    /// </summary>
    [TestMethod]
    [TestCategory("DebugTest")]
    public void DebugEnvironment()
    {
        Debug.WriteLine($"Current Directory: {Environment.CurrentDirectory}");

        Environment
            .GetEnvironmentVariable("PATH")?
            .Split(';')
            .ToList()
            .ForEach(p => Debug.WriteLine($"PATH: {p}"))
        ;
    }

    /// <summary>
    /// Generates a new GUID v7.
    /// </summary>
    [TestMethod]
    [TestCategory("DebugTest")]
    public void DebugGuid()
    {
        Debug.WriteLine(Guid.CreateVersion7());
    }

    /// <summary>
    /// Tests path parsing and manipulation.
    /// </summary>
    [TestMethod]
    [TestCategory("DebugTest")]
    public void DebugFileSystem()
    {
        var path = @"C:\folder\file.ext";

        Debug.WriteLine(path);
        Debug.WriteLine(Path.GetDirectoryName(path));
        Debug.WriteLine(Path.GetFileName(path));
    }

    /// <summary>
    /// Tests PowerShell scripting capabilities (currently broken with Application Insights 3.2.0).
    /// </summary>
    [TestMethod]
    [TestCategory("DebugTest")]
    [Ignore("Broken During Application Insights 3.2.0")]
    public void DebugPowerShell()
    {

        using PowerShell ps = PowerShell.Create();

        ps.AddScript("$DebugPreference = 'Continue';");
        ps.AddScript("$ErrorPreference = 'Continue';");
        ps.AddScript("$InformationPreference = 'Continue';");
        ps.AddScript("$VerbosePreference = 'Continue';");
        ps.AddScript("$WarningPreference = 'Continue';");
        ps.AddScript("Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process;");
        ps.AddScript(@"D:\repos\ronhowe\code\powershell\script\Debug-AzureAutomationRunbook.ps1");

        Debug.WriteLine("Running PowerShell Script");

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

    /// <summary>
    /// Generates a cryptographically secure 4096-bit random key.
    /// </summary>
    [TestMethod]
    [TestCategory("DebugTest")]
    public void DebugRandomKey()
    {
        byte[] buffer = new byte[4096 / 8];
        RandomNumberGenerator.Fill(buffer);
        string key = Convert.ToBase64String(buffer);

        Debug.WriteLine(key);
    }
}
