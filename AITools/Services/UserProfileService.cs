using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace AITools.Services;


//  UserProfileService
//
//  Avatar flow (3 steps):
//    1. POST /UserProfiles/upload
//         multipart/form-data → { content: "uuid.jpg" }
//    2. GET  /UserProfiles/addHeadImage
//         ?userId=UID...&avatarUrl=http://host/UserProfiles/download?name=uuid.jpg
//         → bool
//    3. GET  /UserProfiles/download?name=uuid.jpg → raw image bytes
//
//  Note:
//    • addHeadImage takes the custom "UID..." STRING userId, not the numeric id.
//    • The avatarUrl parameter value must be the FULL download URL so the DB
//      stores a ready-to-use link (matches Mapper: avatar_url = #{avatarUrl}).

public class UserProfileService
{
    private static readonly HttpClient _http = new()
    {
        BaseAddress = new Uri(ApiConfig.BaseUrl),
        Timeout = TimeSpan.FromSeconds(30)
    };

    
    //  UpdateProfileAsync
    
    public async Task<(bool success, string? error)> UpdateProfileAsync(
        long userId,
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

    
    //  GetProfileAsync
    
    public async Task<(UserProfileDto? profile, string? error)> GetProfileAsync(long userId)
    {
        try
        {
            var resp = await _http.GetAsync($"/UserProfiles/selectById?userId={userId}");
            var json = await resp.Content.ReadAsStringAsync();
            var result = JsonSerializer.Deserialize<ListApiResult<UserProfileEntity>>(
                             json, JsonOptions.Default);

            if (result?.Data == null || result.Data.Count == 0)
                return (null, null);

            var p = result.Data[0];
            string avatarFileName = "";

            if (!string.IsNullOrEmpty(p.AvatarUrl))
            {
                var uri = new Uri(p.AvatarUrl);
                var query = System.Web.HttpUtility.ParseQueryString(uri.Query);
                avatarFileName = query["name"] ?? "";
            }

            // 👉 Save locally
            if (!string.IsNullOrEmpty(avatarFileName))
            {
                Preferences.Set("avatarFileName", avatarFileName);
            }
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

    
    //  UploadAvatarAsync
    //  Step 1: POST /UserProfiles/upload (multipart/form-data)
    //  Returns the server-generated filename e.g. "a3f8…jpg".
    
    public async Task<(string? fileName, string? error)> UploadAvatarAsync(
        Stream imageStream, string originalFileName)
    {
        try
        {
            using var form = new MultipartFormDataContent();
            using var content = new StreamContent(imageStream);

            var ext = Path.GetExtension(originalFileName).ToLowerInvariant();
            var mimeType = ext switch
            {
                ".png" => "image/png",
                ".gif" => "image/gif",
                ".webp" => "image/webp",
                _ => "image/jpeg"
            };
            content.Headers.ContentType = new MediaTypeHeaderValue(mimeType);
            form.Add(content, "file", originalFileName);

            var resp = await _http.PostAsync("/UserProfiles/upload", form);
            var json = await resp.Content.ReadAsStringAsync();

            System.Diagnostics.Debug.WriteLine(
                $"[Upload] Status: {resp.StatusCode}, Body: {json}");

            if (!resp.IsSuccessStatusCode)
                return (null, $"HTTP {(int)resp.StatusCode}: {json}");

            // Response: { "content": "uuid.jpg" }
            using var doc = JsonDocument.Parse(json);
            string? fileName = null;

            if (doc.RootElement.TryGetProperty("content", out var c))
                fileName = c.GetString();
            else if (doc.RootElement.TryGetProperty("data", out var d))
                fileName = d.GetString();
            else if (doc.RootElement.ValueKind == JsonValueKind.String)
                fileName = doc.RootElement.GetString();

            return string.IsNullOrEmpty(fileName)
                ? (null, $"Server returned unexpected JSON: {json}")
                : (fileName, null);
        }
        catch (Exception ex)
        {
            return (null, $"Upload error: {ex.Message}");
        }
    }

    
    //  BindAvatarAsync
    //  Step 2: GET /UserProfiles/addHeadImage
    //              ?userId=UID...&avatarUrl=<full download URL>
    //
    //  FIX: parameter was named "headImage" → must be "avatarUrl"
    //       (matches @RequestParam String avatarUrl in the Controller).
    //  The VALUE stored in the DB is the full download URL so the app
    //  can load it directly without rebuilding it later.
    
    public async Task<(bool success, string? error)> BindAvatarAsync(
        string uidString, string serverFileName)
    {
        try
        {
            // Build the full download URL that will be persisted in avatar_url column
            var fullAvatarUrl = AvatarDownloadUrl(serverFileName);

            // Controller signature:
            //   addHeadImage(@RequestParam String userId,
            //                @RequestParam String avatarUrl)
            var requestUrl =
                $"/UserProfiles/addHeadImage" +
                $"?userId={Uri.EscapeDataString(uidString)}" +
                $"&avatarUrl={Uri.EscapeDataString(fullAvatarUrl)}";   // ← was "headImage"

            var resp = await _http.GetAsync(requestUrl);
            var body = await resp.Content.ReadAsStringAsync();

            System.Diagnostics.Debug.WriteLine(
                $"[BindAvatar] Status: {resp.StatusCode}, Body: {body}");

            if (bool.TryParse(body.Trim(), out bool ok) && ok)
                return (true, null);

            return (false, $"Server returned: {body}");
        }
        catch (Exception ex)
        {
            return (false, $"Bind error: {ex.Message}");
        }
    }

    
    //  DownloadAvatarAsync
    //  Step 3: GET /UserProfiles/download?name=uuid.jpg
    
    public async Task<byte[]?> DownloadAvatarAsync(string serverFileName)
    {
        try
        {
            var resp = await _http.GetAsync(
                $"/UserProfiles/download?name={Uri.EscapeDataString(serverFileName)}");
            return resp.IsSuccessStatusCode
                ? await resp.Content.ReadAsByteArrayAsync()
                : null;
        }
        catch
        {
            return null;
        }
    }

    
    //  AvatarDownloadUrl  — full URL for display / DB storage
    
    public static string AvatarDownloadUrl(string serverFileName) =>
        $"{ApiConfig.BaseUrl}/UserProfiles/download?name={Uri.EscapeDataString(serverFileName)}";

    // ── Gender helpers 
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


//  Models


public class UserProfileEntity
{
    public long? UserId { get; set; }

    [JsonPropertyName("realName")]
    public string? RealName { get; set; }
    public string? AvatarUrl { get; set; }
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