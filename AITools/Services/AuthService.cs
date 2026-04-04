using System.Text;
using System.Text.Json;

namespace AITools.Services;

// ─────────────────────────────────────────────────────────────
//  AuthService
//  Login  → GET /Users/selectByUsername?username=xxx
//  Register → POST /Users/insertUser
// ─────────────────────────────────────────────────────────────
public class AuthService
{
    private static readonly HttpClient _http = new()
    {
        BaseAddress = new Uri(ApiConfig.BaseUrl),
        Timeout = TimeSpan.FromSeconds(15)
    };

    // ── Login ──────────────────────────────────────────────────
    public async Task<(UserDto? user, string? error)> LoginAsync(
        string username, string password)
    {
        try
        {
            var resp = await _http.GetAsync(
                $"/Users/selectByUsername?username={Uri.EscapeDataString(username)}");
            var json = await resp.Content.ReadAsStringAsync();

            var result = JsonSerializer.Deserialize<ListApiResult<UsersEntity>>(
                json, JsonOptions.Default);

            if (result?.Data == null || result.Data.Count == 0)
                return (null, "Username not found. Please check and try again.");

            var found = result.Data[0];

            if (found.PasswordHash != password)
                return (null, "Incorrect password. Please try again.");

            var dto = new UserDto
            {
                // DbId is the auto-increment primary key (users.id),
                // used as the foreign key in user_profiles.user_id
                DbId = found.Id ?? 0,
                UserId = found.UserId ?? string.Empty,
                Username = found.Username ?? string.Empty,
                Email = found.Email ?? string.Empty,
                AvatarUrl = found.AvatarUrl ?? string.Empty
            };
            return (dto, null);
        }
        catch (Exception ex)
        {
            return (null, $"Network error: {ex.Message}");
        }
    }

    // ── Register ───────────────────────────────────────────────
    public async Task<(bool success, string? error)> RegisterAsync(
        string username, string email, string password, string userId)
    {
        try
        {
            // Check duplicate username
            var checkResp = await _http.GetAsync(
                $"/Users/selectByUsername?username={Uri.EscapeDataString(username)}");
            var checkJson = await checkResp.Content.ReadAsStringAsync();
            var checkResult = JsonSerializer.Deserialize<ListApiResult<UsersEntity>>(
                checkJson, JsonOptions.Default);

            if (checkResult?.Data != null && checkResult.Data.Count > 0)
                return (false, "Username already taken. Please choose another.");

            var now = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            var payload = new
            {
                userId,
                username,
                email,
                passwordHash = password,
                avatarUrl = string.Empty,
                lastLoginAt = now,
                createdAt = now
            };

            var body = JsonSerializer.Serialize(payload);
            var content = new StringContent(body, Encoding.UTF8, "application/json");
            var resp = await _http.PostAsync("/Users/insertUser", content);
            var json = await resp.Content.ReadAsStringAsync();

            if (bool.TryParse(json.Trim(), out bool ok) && ok)
                return (true, null);

            return (false, "Registration failed. Please try again.");
        }
        catch (Exception ex)
        {
            return (false, $"Network error: {ex.Message}");
        }
    }
}

// ─────────────────────────────────────────────────────────────
//  Response models
// ─────────────────────────────────────────────────────────────

public class ListApiResult<T>
{
    public int Code { get; set; }
    public string? Message { get; set; }
    public int Total { get; set; }
    public List<T>? Data { get; set; }
}

public class UsersEntity
{
    public long? Id { get; set; }   // Auto-increment PK — needed for UserProfiles FK
    public string? UserId { get; set; }   // Custom "UID..." string
    public string? Username { get; set; }
    public string? Email { get; set; }
    public string? PasswordHash { get; set; }
    public string? AvatarUrl { get; set; }
    public string? LastLoginAt { get; set; }
    public string? CreatedAt { get; set; }
}

public class UserDto
{
    public long DbId { get; set; }   // users.id (auto-increment) — FK for user_profiles
    public string UserId { get; set; } = string.Empty;   // Custom "UID..." display ID
    public string? Username { get; set; }
    public string? Email { get; set; }
    public string? AvatarUrl { get; set; }
    public string? Bio { get; set; }
    public string? Gender { get; set; }
}
