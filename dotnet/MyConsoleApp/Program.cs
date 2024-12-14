﻿/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using FluentAssertions;
using System.Diagnostics;
using System.Net;

namespace MyConsoleApp;

public class Program
{
    static void Main(string[] args)
    {
        if (args.Length == 0 || !Uri.TryCreate(args[0], UriKind.Absolute, out Uri? uri))
        {
            uri = new Uri("https://LOCALHOST:444/api/MyService?input=false");
        }

        var background = Console.BackgroundColor;
        Console.CancelKeyPress += (sender, e) =>
        {
            Console.BackgroundColor = background;
            Console.Clear();
        };

        Stopwatch stopwatch = new();

        while (true)
        {
            HttpClient client = new();

            stopwatch.Start();

            try
            {
                var response = client.GetAsync(uri).Result;
                response.StatusCode.Should().Be(HttpStatusCode.OK);

                Refresh("OK", stopwatch.ElapsedMilliseconds, uri, ConsoleColor.DarkGreen);

                foreach (var header in response.Headers)
                {
                    if (header.Key == "CustomHeader")
                    {
                        Console.WriteLine($"{header.Key} = {header.Value.FirstOrDefault()}");
                    }
                }
            }
            catch (Exception e)
            {
                Refresh(e.Message, stopwatch.ElapsedMilliseconds, uri, ConsoleColor.DarkRed);
            }
            finally
            {
                stopwatch.Stop();
                stopwatch.Reset();
                client.Dispose();
            }

            Thread.Sleep(1000);
        }
    }

    private static void Refresh(string message, long duration, Uri uri, ConsoleColor color)
    {
        Console.BackgroundColor = color;
        Console.Clear();
        Console.WriteLine($"{DateTime.UtcNow} - {uri} - {message} - {duration} ms");
    }
}
