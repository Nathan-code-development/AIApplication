using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;

namespace AITools.Services;

//  DTOs
public class TopicDto
{
    public long Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public int MessageCount { get; set; }
    public string CreatedAt { get; set; } = string.Empty;
    public string UpdatedAt { get; set; } = string.Empty;
}

public class ChatMessageDto
{
    public long Id { get; set; }
    public long TopicId { get; set; }
    public long UserId { get; set; }
    /// <summary>1 = user, 2 = assistant</summary>
    public int Role { get; set; }
    public string Content { get; set; } = string.Empty;
    public string CreatedAt { get; set; } = string.Empty;

    public string RoleLabel => Role == 1 ? "user" : "assistant";
}

//  ChatApiService
public class ChatApiService
{
    private const string BaseUrl = "http://121.40.144.4:380";

    private static readonly HttpClient _http = new()
    {
        Timeout = TimeSpan.FromSeconds(15)
    };

    private static string Now() => DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");

    // ── Safe readers: handle both JSON number AND JSON string ─────────────
    // Spring Boot / Jackson sometimes serialises numeric DB columns as strings.
    private static int SafeGetInt(JsonElement el, string prop)
    {
        if (!el.TryGetProperty(prop, out var v)) return 0;
        return v.ValueKind switch
        {
            JsonValueKind.Number => v.GetInt32(),
            JsonValueKind.String => int.TryParse(v.GetString(), out var p) ? p : 0,
            _ => 0
        };
    }

    private static long SafeGetLong(JsonElement el, string prop)
    {
        if (!el.TryGetProperty(prop, out var v)) return 0L;
        return v.ValueKind switch
        {
            JsonValueKind.Number => v.GetInt64(),
            JsonValueKind.String => long.TryParse(v.GetString(), out var p) ? p : 0L,
            _ => 0L
        };
    }

    private static string SafeGetString(JsonElement el, string prop)
    {
        if (!el.TryGetProperty(prop, out var v)) return string.Empty;
        return v.GetString() ?? string.Empty;
    }


    //  GetTopicsAsync  (newest first)

    public async Task<List<TopicDto>> GetTopicsAsync(long userId)
    {
        var resp = await _http.GetAsync($"{BaseUrl}/Topics/selectByUserId?userId={userId}");
        if (!resp.IsSuccessStatusCode) return [];

        var doc = JsonDocument.Parse(await resp.Content.ReadAsStringAsync());
        if (!doc.RootElement.TryGetProperty("data", out var data) ||
            data.ValueKind != JsonValueKind.Array)
            return [];

        var list = new List<TopicDto>();
        foreach (var el in data.EnumerateArray())
        {
            list.Add(new TopicDto
            {
                Id = SafeGetLong(el, "id"),
                Title = SafeGetString(el, "title"),
                MessageCount = SafeGetInt(el, "messageCount"),
                CreatedAt = SafeGetString(el, "createdAt"),
                UpdatedAt = SafeGetString(el, "updatedAt"),
            });
        }

        // Backend returns ORDER BY updated_at DESC; enforce client-side too
        list.Sort((a, b) =>
        {
            var sa = string.IsNullOrEmpty(a.UpdatedAt) ? a.CreatedAt : a.UpdatedAt;
            var sb = string.IsNullOrEmpty(b.UpdatedAt) ? b.CreatedAt : b.UpdatedAt;
            DateTime.TryParse(sb, out var dtB);
            DateTime.TryParse(sa, out var dtA);
            return dtB.CompareTo(dtA);
        });

        return list;
    }


    //  GetMessagesAsync  (oldest first = conversation order)
    //  FIX: SafeGetInt handles "role" whether it comes back as
    //       a JSON number or a JSON string from Spring Boot.

    public async Task<List<ChatMessageDto>> GetMessagesAsync(long topicId)
    {
        var resp = await _http.GetAsync(
            $"{BaseUrl}/ChatMessage/selectByTopicId?topicId={topicId}");
        if (!resp.IsSuccessStatusCode) return [];

        var doc = JsonDocument.Parse(await resp.Content.ReadAsStringAsync());
        if (!doc.RootElement.TryGetProperty("data", out var data) ||
            data.ValueKind != JsonValueKind.Array)
            return [];

        var list = new List<ChatMessageDto>();
        foreach (var el in data.EnumerateArray())
        {
            list.Add(new ChatMessageDto
            {
                Id = SafeGetLong(el, "id"),
                TopicId = SafeGetLong(el, "topicId"),
                UserId = SafeGetLong(el, "userId"),
                Role = SafeGetInt(el, "role"),   // ← was crashing before
                Content = SafeGetString(el, "content"),
                CreatedAt = SafeGetString(el, "createdAt"),
            });
        }

        list.Sort((a, b) =>
        {
            DateTime.TryParse(a.CreatedAt, out var dtA);
            DateTime.TryParse(b.CreatedAt, out var dtB);
            return dtA.CompareTo(dtB);
        });

        return list;
    }

    
    //  EnsureTopicAsync
    
    public async Task<long> EnsureTopicAsync(long userId, long topicId, string firstUserMessage)
    {
        if (topicId != 0) return topicId;

        var title = firstUserMessage.Length > 200
            ? firstUserMessage[..197] + "..."
            : firstUserMessage;

        var body = new JsonObject
        {
            ["userId"] = userId,
            ["title"] = title,
            ["messageCount"] = 0,
            ["createdAt"] = Now()
        };

        var insertResp = await _http.SendAsync(new HttpRequestMessage(
            HttpMethod.Post, $"{BaseUrl}/Topics/insertTopics")
        {
            Content = new StringContent(body.ToJsonString(), Encoding.UTF8, "application/json")
        });

        if (!insertResp.IsSuccessStatusCode)
            throw new HttpRequestException(
                $"insertTopics {(int)insertResp.StatusCode}: {await insertResp.Content.ReadAsStringAsync()}");

        var listResp = await _http.GetAsync($"{BaseUrl}/Topics/selectByUserId?userId={userId}");
        if (!listResp.IsSuccessStatusCode)
            throw new HttpRequestException(
                $"selectByUserId {(int)listResp.StatusCode}: {await listResp.Content.ReadAsStringAsync()}");

        var doc = JsonDocument.Parse(await listResp.Content.ReadAsStringAsync());
        var data = doc.RootElement.GetProperty("data");

        if (data.ValueKind != JsonValueKind.Array || data.GetArrayLength() == 0)
            throw new HttpRequestException("selectByUserId returned empty list after insert.");

        long newId = 0;
        foreach (var el in data.EnumerateArray())
        {
            var id = SafeGetLong(el, "id");
            if (id > newId) newId = id;
        }
        return newId;
    }

    private static int MapRole(string role) =>
        role switch { "user" => 1, "assistant" => 2, _ => 0 };

    
    //  SaveMessageAsync
    
    public async Task SaveMessageAsync(long topicId, long userId, string role, string content)
    {
        var body = new JsonObject
        {
            ["topicId"] = topicId,
            ["userId"] = userId,
            ["role"] = MapRole(role),
            ["content"] = content,
            ["tokensUsed"] = 0,
            ["createdAt"] = Now()
        };

        var resp = await _http.SendAsync(new HttpRequestMessage(
            HttpMethod.Post, $"{BaseUrl}/ChatMessage/insertChatMessages")
        {
            Content = new StringContent(body.ToJsonString(), Encoding.UTF8, "application/json")
        });

        if (!resp.IsSuccessStatusCode)
            throw new HttpRequestException(
                $"insertChatMessages {(int)resp.StatusCode}: {await resp.Content.ReadAsStringAsync()}");

        _ = _http.GetAsync($"{BaseUrl}/Topics/incrementMessageCount?id={topicId}");
    }

    //  DeleteAllTopicsAsync
    // Delete all the chat records of the user (including all topics and messages).
    public async Task DeleteAllTopicsAsync(long userId)
    {
        var topics = await GetTopicsAsync(userId);
        foreach (var topic in topics)
            await _http.GetAsync($"{BaseUrl}/ChatMessage/deleteByTopicId?topicId={topic.Id}");
        await _http.GetAsync($"{BaseUrl}/Topics/deleteByUserId?userId={userId}");
    }

    /// Delete all chat messages under the specified topic (keep the topic itself intact)
    public async Task<bool> DeleteMessagesByTopicIdAsync(long topicId)
    {
        try
        {
            var resp = await _http.GetAsync($"{BaseUrl}/ChatMessage/deleteByTopicId?topicId={topicId}");
            var content = await resp.Content.ReadAsStringAsync();
            return resp.IsSuccessStatusCode && bool.TryParse(content.Trim(), out var ok) && ok;
        }
        catch
        {
            return false;
        }
    }

}
