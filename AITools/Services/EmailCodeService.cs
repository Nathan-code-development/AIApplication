using System.Text;
using System.Text.Json;

namespace AITools.Services;

// ─────────────────────────────────────────────────────────────
//  EmailCodeService
//  Calls the real backend endpoints:
//    POST /api/v1/email/send-code    body: { "email": "..." }
//    POST /api/v1/email/verify-code  body: { "email": "...", "code": "..." }
//
//  Both return ApiResponse<Void>: { code, message, data }
//  code == 200 means success.
// ─────────────────────────────────────────────────────────────
public class EmailCodeService
{
    private static readonly HttpClient _http = new()
    {
        BaseAddress = new Uri(ApiConfig.BaseUrl),
        Timeout = TimeSpan.FromSeconds(15)
    };

    /// <summary>
    /// Sends a 6-digit verification code to the given email address.
    /// The backend rate-limits to one request per 60 seconds per email.
    /// </summary>
    public async Task<(bool success, string? error)> SendCodeAsync(string email)
    {
        try
        {
            var body = JsonSerializer.Serialize(new { email });
            var content = new StringContent(body, Encoding.UTF8, "application/json");
            var resp = await _http.PostAsync("/api/v1/email/send-code", content);
            var json = await resp.Content.ReadAsStringAsync();
            var result = JsonSerializer.Deserialize<ApiCodeResult>(json, JsonOptions.Default);

            if (result?.Code == 200)
                return (true, null);

            // Surface the backend's error message (e.g. "请求过于频繁，请60秒后再试")
            return (false, result?.Message ?? "Failed to send verification code. Please try again.");
        }
        catch (Exception ex)
        {
            return (false, $"Network error: {ex.Message}");
        }
    }

    /// <summary>
    /// Verifies the 6-digit code the user entered against the backend / Redis store.
    /// Returns success only when code == 200.
    /// </summary>
    public async Task<(bool success, string? error)> VerifyCodeAsync(string email, string code)
    {
        try
        {
            var body = JsonSerializer.Serialize(new { email, code });
            var content = new StringContent(body, Encoding.UTF8, "application/json");
            var resp = await _http.PostAsync("/api/v1/email/verify-code", content);
            var json = await resp.Content.ReadAsStringAsync();
            var result = JsonSerializer.Deserialize<ApiCodeResult>(json, JsonOptions.Default);

            if (result?.Code == 200)
                return (true, null);

            // Possible messages: "验证码错误" / "验证码已过期，请重新获取"
            return (false, result?.Message ?? "Incorrect or expired verification code.");
        }
        catch (Exception ex)
        {
            return (false, $"Network error: {ex.Message}");
        }
    }

    // Minimal model for ApiResponse<Void>: { code, message, data }
    private class ApiCodeResult
    {
        public int Code { get; set; }
        public string? Message { get; set; }
    }
}