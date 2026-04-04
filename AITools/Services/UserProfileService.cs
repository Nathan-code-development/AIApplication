using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace AITools.Services;

// ─────────────────────────────────────────────────────────────
//  UserProfileService
//
//  Key design note:
//    Backend UserProfiles.userId is Long — it maps to users.id
//    (the auto-increment primary key), NOT the "UID..." string.
//    We store that value in Preferences under "userDbId" at login.
//
//  Endpoints used:
//    POST /UserProfiles/insertUserProfiles  — upsert (ON DUPLICATE KEY)
//    POST /UserProfiles/updateUserProfiles  — update existing row
//    GET  /UserProfiles/selectById?userId=x — fetch profile
// ─────────────────────────────────────────────────────────────
public class UserProfileService
{
    private static readonly HttpClient _http = new()
    {
        BaseAddress = new Uri(ApiConfig.BaseUrl),
        Timeout = TimeSpan.FromSeconds(15)
    };

    /// <summary>
    /// Saves the user's profile (insert or update).
    /// Uses insertUserProfiles which has ON DUPLICATE KEY UPDATE,
    /// so it safely handles both first-time save and subsequent edits.
    /// </summary>
    public async Task<(bool success, string? error)> UpdateProfileAsync(
        long userId,       // users.id auto-increment value stored as "userDbId"
        string displayName,
        string genderLabel,
        string bio,
        string phone = "")
    {
        try
        {
            var payload = new
            {
                userId,
                realName = displayName,
                gender = GenderLabelToInt(genderLabel),
                introduction = bio,
                phone = string.IsNullOrEmpty(phone) ? (string?)null : phone
            };

            var body = JsonSerializer.Serialize(payload);
            var content = new StringContent(body, Encoding.UTF8, "application/json");

            // Use insertUserProfiles — it does ON DUPLICATE KEY UPDATE,
            // so it works for both new profiles and updates.
            var resp = await _http.PostAsync("/UserProfiles/insertUserProfiles", content);
            var json = await resp.Content.ReadAsStringAsync();

            if (bool.TryParse(json.Trim(), out bool ok) && ok)
                return (true, null);

            return (false, "Failed to save profile. Please try again.");
        }
        catch (Exception ex)
        {
            return (false, $"Network error: {ex.Message}");
        }
    }

    /// <summary>
    /// Fetches the saved profile for display (e.g. on Myself page).
    /// </summary>
    public async Task<(UserProfileDto? profile, string? error)> GetProfileAsync(long userId)
    {
        try
        {
            var resp = await _http.GetAsync(
                $"/UserProfiles/selectById?userId={userId}");
            var json = await resp.Content.ReadAsStringAsync();
            var result = JsonSerializer.Deserialize<ListApiResult<UserProfileEntity>>(
                json, JsonOptions.Default);

            if (result?.Data == null || result.Data.Count == 0)
                return (null, null);  // No profile yet — not an error

            var p = result.Data[0];
            return (new UserProfileDto
            {
                RealName = p.RealName ?? string.Empty,
                GenderLabel = GenderIntToLabel(p.Gender),
                Introduction = p.Introduction ?? string.Empty,
                Phone = p.Phone ?? string.Empty
            }, null);
        }
        catch (Exception ex)
        {
            return (null, $"Network error: {ex.Message}");
        }
    }

    // ── Gender conversion helpers ─────────────────────────────
    private static int? GenderLabelToInt(string label) => label switch
    {
        "Male" => 0,
        "Female" => 1,
        "Non-binary" => 2,
        "Prefer not to say" => 3,
        _ => (int?)null
    };

    public static string GenderIntToLabel(int? gender) => gender switch
    {
        0 => "Male",
        1 => "Female",
        2 => "Non-binary",
        3 => "Prefer not to say",
        _ => string.Empty
    };
}

// ─────────────────────────────────────────────────────────────
//  Models
// ─────────────────────────────────────────────────────────────

public class UserProfileEntity
{
    public long? UserId { get; set; }

    [JsonPropertyName("realName")]
    public string? RealName { get; set; }

    public int? Gender { get; set; }
    public string? Introduction { get; set; }
    public string? Phone { get; set; }
    public string? UpdatedAt { get; set; }
}

public class UserProfileDto
{
    public string RealName { get; set; } = string.Empty;
    public string GenderLabel { get; set; } = string.Empty;
    public string Introduction { get; set; } = string.Empty;
    public string Phone { get; set; } = string.Empty;
}