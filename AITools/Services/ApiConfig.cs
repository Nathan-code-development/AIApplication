using System.Text.Json;

namespace AITools.Services;

/// <summary>
/// Central place to change the backend base URL.
/// Android emulator → host : "http://10.0.2.2:380"
/// Real device / production : "http://121.40.144.4:380"
/// </summary>
public static class ApiConfig
{
    public const string BaseUrl = "http://121.40.144.4:380";
}

/// <summary>
/// Shared JsonSerializerOptions used by all service classes.
/// Case-insensitive to match Spring Boot's camelCase JSON output.
/// </summary>
public static class JsonOptions
{
    public static readonly JsonSerializerOptions Default = new()
    {
        PropertyNameCaseInsensitive = true
    };
}