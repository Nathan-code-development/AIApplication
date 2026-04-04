using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;

namespace AITools.Services;

// ─────────────────────────────────────────────────────────────
//  AI Model enum
// ─────────────────────────────────────────────────────────────
public enum AiModel { DeepSeek, Doubao, Qianwen }

// ─────────────────────────────────────────────────────────────
//  Attachment
// ─────────────────────────────────────────────────────────────
public class AiAttachment
{
    public string FileName { get; set; } = string.Empty;
    public string MimeType { get; set; } = string.Empty;
    public byte[] Data { get; set; } = [];
    public bool IsImage => MimeType.StartsWith("image/");
}

// ─────────────────────────────────────────────────────────────
//  One turn in the conversation history
// ─────────────────────────────────────────────────────────────
public class ChatTurn
{
    public string Role { get; set; } = "user";
    public string Content { get; set; } = string.Empty;
}

// ─────────────────────────────────────────────────────────────
//  AiApiService
// ─────────────────────────────────────────────────────────────
public class AiApiService
{
    // ── API Keys ──────────────────────────────────────────────
    private const string DeepSeekApiKey = "sk-8acfd1b2b6644ce7bb2034c34d21ce38";
    private const string DoubaoApiKey = "3bcca3cf-e17d-4bbe-a8b4-e48746c99489";
    private const string QianwenApiKey = "sk-1d43156f789841aba38bdaeb077bec24";

    // ── Model identifiers ─────────────────────────────────────
    // deepseek-chat and deepseek-reasoner are the only models on
    // api.deepseek.com — neither supports image input.
    private const string DeepSeekModel = "deepseek-chat";
    private const string DoubaoModel = "doubao-seed-2-0-code-preview-260215";
    // qwen-vl-plus supports both text and image input
    private const string QianwenModel = "qwen-vl-plus";

    // ── Base URLs ─────────────────────────────────────────────
    private const string DeepSeekUrl = "https://api.deepseek.com/v1/chat/completions";
    private const string DoubaoUrl = "https://ark.cn-beijing.volces.com/api/v3/chat/completions";
    private const string QianwenUrl = "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions";

    private static readonly HttpClient _http = new() { Timeout = TimeSpan.FromSeconds(60) };

    // ─────────────────────────────────────────────────────────
    //  Main entry point
    // ─────────────────────────────────────────────────────────
    public async Task<(string reply, string? error)> SendAsync(
        AiModel model,
        string userMessage,
        List<ChatTurn> history,
        List<AiAttachment>? attachments = null)
    {
        // DeepSeek does not support image input — reject early with a clear message
        bool hasImages = attachments?.Any(a => a.IsImage) == true;
        if (model == AiModel.DeepSeek && hasImages)
            return (string.Empty,
                "DeepSeek does not support image input. Please use Qwen or Doubao to send images.");

        try
        {
            var (url, apiKey, modelId) = GetConfig(model);

            var messages = new JsonArray();

            messages.Add(new JsonObject
            {
                ["role"] = "system",
                ["content"] = "You are a helpful AI assistant. Be concise and friendly."
            });

            foreach (var turn in history.TakeLast(10))
                messages.Add(new JsonObject
                {
                    ["role"] = turn.Role,
                    ["content"] = turn.Content
                });

            messages.Add(BuildUserMessage(userMessage, attachments));

            var requestBody = new JsonObject
            {
                ["model"] = modelId,
                ["messages"] = messages,
                ["max_tokens"] = 2048,
                ["temperature"] = 0.7
            };

            var request = new HttpRequestMessage(HttpMethod.Post, url)
            {
                Content = new StringContent(
                    requestBody.ToJsonString(), Encoding.UTF8, "application/json")
            };
            request.Headers.Authorization =
                new AuthenticationHeaderValue("Bearer", apiKey);

            var response = await _http.SendAsync(request);
            var json = await response.Content.ReadAsStringAsync();

            if (!response.IsSuccessStatusCode)
                return (string.Empty, $"API error {(int)response.StatusCode}: {ExtractErrorMsg(json)}");

            var reply = ExtractReply(json);
            return (reply, null);
        }
        catch (TaskCanceledException)
        {
            return (string.Empty, "Request timed out. Please try again.");
        }
        catch (Exception ex)
        {
            return (string.Empty, $"Network error: {ex.Message}");
        }
    }

    // ─────────────────────────────────────────────────────────
    //  Build user message — plain text or multipart with images
    // ─────────────────────────────────────────────────────────
    private static JsonNode BuildUserMessage(
        string userMessage, List<AiAttachment>? attachments)
    {
        if (attachments == null || attachments.Count == 0)
            return new JsonObject { ["role"] = "user", ["content"] = userMessage };

        var contentArray = new JsonArray();

        // Non-image files: read as text and prepend
        var textParts = new StringBuilder();
        foreach (var att in attachments.Where(a => !a.IsImage))
        {
            try
            {
                var text = Encoding.UTF8.GetString(att.Data);
                textParts.AppendLine($"[File: {att.FileName}]");
                textParts.AppendLine(text);
                textParts.AppendLine();
            }
            catch
            {
                textParts.AppendLine($"[Attached binary file: {att.FileName} — cannot display inline]");
            }
        }

        var fullText = textParts.Length > 0
            ? textParts + "\n" + userMessage
            : userMessage;

        contentArray.Add(new JsonObject
        {
            ["type"] = "text",
            ["text"] = fullText
        });

        // Images: base64 data URL — OpenAI vision format (supported by Qwen VL and Doubao)
        foreach (var att in attachments.Where(a => a.IsImage))
        {
            var base64 = Convert.ToBase64String(att.Data);
            contentArray.Add(new JsonObject
            {
                ["type"] = "image_url",
                ["image_url"] = new JsonObject
                {
                    ["url"] = $"data:{att.MimeType};base64,{base64}",
                    ["detail"] = "auto"
                }
            });
        }

        return new JsonObject { ["role"] = "user", ["content"] = contentArray };
    }

    // ─────────────────────────────────────────────────────────
    //  GetConfig
    // ─────────────────────────────────────────────────────────
    private static (string url, string key, string model) GetConfig(AiModel model) =>
        model switch
        {
            AiModel.DeepSeek => (DeepSeekUrl, DeepSeekApiKey, DeepSeekModel),
            AiModel.Doubao => (DoubaoUrl, DoubaoApiKey, DoubaoModel),
            AiModel.Qianwen => (QianwenUrl, QianwenApiKey, QianwenModel),
            _ => throw new ArgumentOutOfRangeException()
        };

    // ─────────────────────────────────────────────────────────
    //  Helpers
    // ─────────────────────────────────────────────────────────
    private static string ExtractReply(string json)
    {
        try
        {
            var doc = JsonDocument.Parse(json);
            return doc.RootElement
                .GetProperty("choices")[0]
                .GetProperty("message")
                .GetProperty("content")
                .GetString() ?? string.Empty;
        }
        catch
        {
            return "Could not parse AI response.";
        }
    }

    private static string ExtractErrorMsg(string json)
    {
        try
        {
            var doc = JsonDocument.Parse(json);
            if (doc.RootElement.TryGetProperty("error", out var err))
                return err.TryGetProperty("message", out var msg)
                    ? msg.GetString() ?? json
                    : json;
        }
        catch { }
        return json;
    }
}
