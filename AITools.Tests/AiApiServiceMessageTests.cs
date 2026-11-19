using System.Text.Json.Nodes;
using AITools.Services;
using Xunit;

namespace AITools.Tests;

public class AiApiServiceMessageTests
{
    private const string SystemPrompt =
        "You are a helpful AI assistant. Be concise and friendly.";

    private static string Role(JsonNode message) =>
        message["role"]!.GetValue<string>();

    private static JsonNode Content(JsonNode message) => message["content"]!;

    [Fact]
    public void FirstTurn_SendsCurrentMessageExactlyOnce()
    {
        var messages = AiApiService.BuildMessages(
            "hello", Array.Empty<ChatTurn>());

        // system + exactly one user turn
        Assert.Equal(2, messages.Count);
        Assert.Equal("system", Role(messages[0]!));
        Assert.Equal(SystemPrompt, Content(messages[0]!).GetValue<string>());
        Assert.Equal("user", Role(messages[1]!));
        Assert.Equal("hello", Content(messages[1]!).GetValue<string>());
    }

    [Fact]
    public void PriorTurns_ArePreservedAndCurrentTurnIsAppendedOnce()
    {
        var history = new List<ChatTurn>
        {
            new() { Role = "user", Content = "first question" },
            new() { Role = "assistant", Content = "first answer" },
        };

        var messages = AiApiService.BuildMessages("second question", history);

        Assert.Equal(4, messages.Count);
        Assert.Equal("first question", Content(messages[1]!).GetValue<string>());
        Assert.Equal("first answer", Content(messages[2]!).GetValue<string>());
        Assert.Equal("second question", Content(messages[3]!).GetValue<string>());
        Assert.Equal(1, CountOccurrences(messages, "second question"));
    }

    [Fact]
    public void HistoryWindow_KeepsOnlyTheLastTenPriorTurns()
    {
        var history = Enumerable.Range(0, 12)
            .Select(i => new ChatTurn { Content = $"turn-{i}" })
            .ToList();

        var messages = AiApiService.BuildMessages("now", history);

        Assert.Equal(1 + 10 + 1, messages.Count);
        Assert.Equal("turn-2", Content(messages[1]!).GetValue<string>());
        Assert.Equal("turn-11", Content(messages[10]!).GetValue<string>());
        Assert.Equal("now", Content(messages[11]!).GetValue<string>());
    }

    [Fact]
    public void ImageAttachment_IsAttachedToTheSingleCurrentUserMessage()
    {
        var attachments = new List<AiAttachment>
        {
            new()
            {
                FileName = "pixel.png",
                MimeType = "image/png",
                Data = [0x89, 0x50, 0x4E, 0x47],
            },
        };

        var messages = AiApiService.BuildMessages(
            "what is this?", Array.Empty<ChatTurn>(), attachments);

        Assert.Equal(2, messages.Count);

        var parts = Content(messages[1]!).AsArray();
        Assert.Equal(2, parts.Count);

        var text = parts[0]!.AsObject();
        Assert.Equal("text", text["type"]!.GetValue<string>());
        Assert.Equal("what is this?", text["text"]!.GetValue<string>());

        var image = parts[1]!.AsObject();
        Assert.Equal("image_url", image["type"]!.GetValue<string>());
        Assert.StartsWith("data:image/png;base64,",
            image["image_url"]!["url"]!.GetValue<string>());

        Assert.Equal(1, CountOccurrences(messages, "what is this?"));
    }

    [Fact]
    public void TextAttachment_PrependsFileContentWithoutDuplicatingTheMessage()
    {
        var attachments = new List<AiAttachment>
        {
            new()
            {
                FileName = "note.txt",
                MimeType = "text/plain",
                Data = "attachment body"u8.ToArray(),
            },
        };

        var messages = AiApiService.BuildMessages(
            "summarize this", Array.Empty<ChatTurn>(), attachments);

        Assert.Equal(2, messages.Count);

        var parts = Content(messages[1]!).AsArray();
        var textPart = Assert.Single(parts);
        var text = textPart!["text"]!.GetValue<string>();

        Assert.Contains("[File: note.txt]", text);
        Assert.Contains("attachment body", text);
        Assert.EndsWith("summarize this", text);
        Assert.Equal(1, CountOccurrences(messages, "summarize this"));
    }

    private static int CountOccurrences(JsonArray messages, string needle)
    {
        var count = 0;
        foreach (var message in messages)
        {
            var content = message!["content"];
            switch (content)
            {
                case JsonValue value when value.TryGetValue<string>(out var text):
                    count += CountIn(text, needle);
                    break;
                case JsonArray parts:
                    foreach (var part in parts)
                        count += CountIn(
                            part!["text"]?.GetValue<string>() ?? string.Empty,
                            needle);
                    break;
            }
        }
        return count;
    }

    private static int CountIn(string haystack, string needle)
    {
        var count = 0;
        var index = 0;
        while ((index = haystack.IndexOf(needle, index, StringComparison.Ordinal)) >= 0)
        {
            count++;
            index += needle.Length;
        }
        return count;
    }
}
