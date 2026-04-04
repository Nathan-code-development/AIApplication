using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;

namespace AITools.Services;

// ─────────────────────────────────────────────────────────────
//  ChatApiService
//  Calls the Spring Boot backend to persist topics and messages.
// ─────────────────────────────────────────────────────────────
public class ChatApiService
{
    private const string BaseUrl = "http://121.40.144.4:380";

    private static readonly HttpClient _http = new()
    {
        Timeout = TimeSpan.FromSeconds(15)
    };

    // 格式必须与后端 @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss") 完全一致
    private static string Now() =>
        DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");

    // ─────────────────────────────────────────────────────────
    //  EnsureTopicAsync
    // ─────────────────────────────────────────────────────────
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

        var insertReq = new HttpRequestMessage(HttpMethod.Post, $"{BaseUrl}/Topics/insertTopics")
        {
            Content = new StringContent(body.ToJsonString(), Encoding.UTF8, "application/json")
        };

        var insertResp = await _http.SendAsync(insertReq);
        if (!insertResp.IsSuccessStatusCode)
        {
            var errBody = await insertResp.Content.ReadAsStringAsync();
            throw new HttpRequestException(
                $"insertTopics {(int)insertResp.StatusCode}: {errBody}");
        }

        var listResp = await _http.GetAsync(
            $"{BaseUrl}/Topics/selectByUserId?userId={userId}");

        if (!listResp.IsSuccessStatusCode)
        {
            var errBody = await listResp.Content.ReadAsStringAsync();
            throw new HttpRequestException(
                $"selectByUserId {(int)listResp.StatusCode}: {errBody}");
        }

        var listJson = await listResp.Content.ReadAsStringAsync();
        var doc = JsonDocument.Parse(listJson);
        var data = doc.RootElement.GetProperty("data");

        if (data.ValueKind != JsonValueKind.Array || data.GetArrayLength() == 0)
            throw new HttpRequestException("selectByUserId succeeded but returned empty topic list.");

        return data[0].GetProperty("id").GetInt64();
    }

    private static int MapRole(string role)
    {
        return role switch
        {
            "user" => 1,
            "assistant" => 2,
            _ => 0
        };
    }

    // ─────────────────────────────────────────────────────────
    //  SaveMessageAsync
    // ─────────────────────────────────────────────────────────
    public async Task SaveMessageAsync(long topicId, long userId, string role, string content)
    {
        var body = new JsonObject
        {
            ["topicId"] = topicId,
            ["userId"] = userId,
            ["role"] = MapRole(role),          // "user" -> 0 | "assistant" -> 1
            ["content"] = content,
            ["tokensUsed"] = 0,
            ["createdAt"] = Now()          // "yyyy-MM-dd HH:mm:ss" — matches @JsonFormat
        };

        var req = new HttpRequestMessage(HttpMethod.Post,
            $"{BaseUrl}/ChatMessage/insertChatMessages")
        {
            Content = new StringContent(body.ToJsonString(), Encoding.UTF8, "application/json")
        };

        var resp = await _http.SendAsync(req);
        if (!resp.IsSuccessStatusCode)
        {
            var errBody = await resp.Content.ReadAsStringAsync();
            throw new HttpRequestException(
                $"insertChatMessages {(int)resp.StatusCode}: {errBody}");
        }

        // Bump message_count (fire-and-forget, non-fatal)
        await _http.GetAsync($"{BaseUrl}/Topics/incrementMessageCount?id={topicId}");
    }
}
