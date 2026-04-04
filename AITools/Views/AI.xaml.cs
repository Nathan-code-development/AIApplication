// FIX 1: Add explicit using for System.IO.Path to resolve CS0104 ambiguity
//         between Microsoft.Maui.Controls.Shapes.Path and System.IO.Path
using AITools.Services;
using Microsoft.Maui.Controls.Shapes;
using IOPath = System.IO.Path;
using System.Diagnostics;      // ← alias so Path always means System.IO.Path below

namespace AITools.Views;

public partial class AI : ContentPage
{
    // ── Services ──────────────────────────────────────────────
    private readonly AiApiService _aiSvc = new();
    private readonly ChatApiService _chatApi = new();

    // ── State ─────────────────────────────────────────────────
    private bool _isAiReplying = false;
    private AiModel _currentModel = AiModel.DeepSeek;
    private View? _currentSuggestionBlock = null;

    // ── Chat persistence ──────────────────────────────────────
    // 0 = no topic created yet for this conversation session
    private long _currentTopicId = 0;

    // Conversation history — sent with every request for context
    private readonly List<ChatTurn> _history = new();
    // Pending attachments (cleared after each send)
    private readonly List<AiAttachment> _attachments = new();

    // ── Suggestion prompts ────────────────────────────────────
    private static readonly string[] Suggestions =
    {
        "What can you help me with?",
        "Summarize a document for me",
        "Write some code",
        "Translate text"
    };

    // Max bubble width: 65% of screen (adapts to phones and tablets)
    private double BubbleMaxWidth =>
        DeviceDisplay.MainDisplayInfo.Width /
        DeviceDisplay.MainDisplayInfo.Density * 0.65;

    public AI()
    {
        InitializeComponent();
        Loaded += (_, _) => AppendSuggestionBlock();
    }

    // ─────────────────────────────────────────────────────────
    //  Model tab switching
    // ─────────────────────────────────────────────────────────
    private void OnModelTabTapped(object sender, TappedEventArgs e)
    {
        if (e.Parameter is not string modelName) return;
        if (!Enum.TryParse<AiModel>(modelName, out var model)) return;
        _currentModel = model;
        UpdateModelTabUI(model);
    }

    private void UpdateModelTabUI(AiModel model)
    {
        SetTabActive(TabDeepSeek, model == AiModel.DeepSeek);
        SetTabActive(TabDoubao, model == AiModel.Doubao);
        SetTabActive(TabQianwen, model == AiModel.Qianwen);

        HeaderModelLabel.Text = model switch
        {
            AiModel.DeepSeek => "DeepSeek Chat",
            AiModel.Doubao => "Doubao AI",
            AiModel.Qianwen => "Qwen AI",
            _ => "AI Chatbox"
        };
    }

    private static void SetTabActive(Border tab, bool active)
    {
        tab.BackgroundColor = active
            ? Color.FromArgb("#1A1A2E")
            : Color.FromArgb("#E8E4F0");

        // Walk into HorizontalStackLayout > second child Label
        if (tab.Content is HorizontalStackLayout hsl && hsl.Count >= 2
            && hsl[1] is Label lbl)
        {
            lbl.TextColor = active ? Colors.White : Color.FromArgb("#4A3F8C");
        }
    }

    // ─────────────────────────────────────────────────────────
    //  Attach image
    //  FIX 2: Use PickPhotosAsync instead of deprecated PickPhotoAsync
    //  FIX 3: Use IOPath alias instead of plain Path to avoid CS0104
    // ─────────────────────────────────────────────────────────
    private async void OnAttachImageTapped(object sender, TappedEventArgs e)
    {
        if (_isAiReplying) return;

        if (_currentModel == AiModel.DeepSeek)
        {
            await DisplayAlertAsync("Not Supported",
                "DeepSeek does not support uploading images for the time being.", "OK");
            return;
        }

        try
        {
            // PickPhotosAsync replaces the deprecated PickPhotoAsync
            var results = await MediaPicker.Default.PickPhotosAsync(
                new MediaPickerOptions { Title = "Select an image" });

            var file = results?.FirstOrDefault();
            if (file == null) return;

            using var stream = await file.OpenReadAsync();
            using var ms = new MemoryStream();
            await stream.CopyToAsync(ms);

            // FIX 3: IOPath alias resolves CS0104
            var ext = IOPath.GetExtension(file.FileName).ToLowerInvariant();
            var mimeType = ext switch
            {
                ".png" => "image/png",
                ".gif" => "image/gif",
                ".webp" => "image/webp",
                _ => "image/jpeg"
            };

            _attachments.Add(new AiAttachment
            {
                FileName = file.FileName,
                MimeType = mimeType,
                Data = ms.ToArray()
            });

            AddAttachmentChip(file.FileName, "🖼");
        }
        catch (Exception ex)
        {
            await DisplayAlertAsync("Error", $"Could not attach image: {ex.Message}", "OK");
        }
    }

    // ─────────────────────────────────────────────────────────
    //  Attach file
    //  FIX 3: Use IOPath alias
    // ─────────────────────────────────────────────────────────
    private async void OnAttachFileTapped(object sender, TappedEventArgs e)
    {
        if (_isAiReplying) return;
        try
        {
            var result = await FilePicker.Default.PickAsync(new PickOptions
            {
                PickerTitle = "Select a file",
                FileTypes = new FilePickerFileType(
                    new Dictionary<DevicePlatform, IEnumerable<string>>
                    {
                        { DevicePlatform.Android,     new[] { "*/*" } },
                        { DevicePlatform.iOS,         new[] { "public.content" } },
                        { DevicePlatform.WinUI,       new[] { "*" } },
                        { DevicePlatform.MacCatalyst, new[] { "public.content" } }
                    })
            });

            if (result == null) return;

            using var stream = await result.OpenReadAsync();
            using var ms = new MemoryStream();
            await stream.CopyToAsync(ms);

            // FIX 3: IOPath alias
            var ext = IOPath.GetExtension(result.FileName).ToLowerInvariant();
            var mimeType = ext switch
            {
                ".pdf" => "application/pdf",
                ".txt" => "text/plain",
                ".md" => "text/markdown",
                ".json" => "application/json",
                ".csv" => "text/csv",
                _ => "application/octet-stream"
            };

            _attachments.Add(new AiAttachment
            {
                FileName = result.FileName,
                MimeType = mimeType,
                Data = ms.ToArray()
            });

            AddAttachmentChip(result.FileName, "📎");
        }
        catch (Exception ex)
        {
            await DisplayAlertAsync("Error", $"Could not attach file: {ex.Message}", "OK");
        }
    }

    // ─────────────────────────────────────────────────────────
    //  Attachment chip (removable badge in the preview bar)
    // ─────────────────────────────────────────────────────────
    private void AddAttachmentChip(string fileName, string icon)
    {
        AttachmentBar.IsVisible = true;

        var displayName = fileName.Length > 16
            ? fileName[..13] + "…"
            : fileName;

        var chip = new Border
        {
            BackgroundColor = Color.FromArgb("#1A1A2E"),
            StrokeThickness = 0,
            Padding = new Thickness(10, 6),
            StrokeShape = new RoundRectangle { CornerRadius = new CornerRadius(12) }
        };

        var chipContent = new HorizontalStackLayout { Spacing = 6 };
        chipContent.Add(new Label { Text = icon, FontSize = 13 });
        chipContent.Add(new Label
        {
            Text = displayName,
            FontSize = 12,
            TextColor = Colors.White,
            VerticalOptions = LayoutOptions.Center
        });

        // ✕ remove button
        var removeBtn = new Label
        {
            Text = " ✕",
            FontSize = 12,
            TextColor = Color.FromArgb("#E94560"),
            VerticalOptions = LayoutOptions.Center
        };

        // Capture attachment index at creation time
        int attachIndex = _attachments.Count - 1;
        removeBtn.GestureRecognizers.Add(new TapGestureRecognizer
        {
            Command = new Command(() =>
            {
                if (attachIndex >= 0 && attachIndex < _attachments.Count)
                    _attachments.RemoveAt(attachIndex);
                AttachmentContainer.Remove(chip);
                if (AttachmentContainer.Count == 0)
                    AttachmentBar.IsVisible = false;
            })
        });

        chipContent.Add(removeBtn);
        chip.Content = chipContent;
        AttachmentContainer.Add(chip);
    }

    // ─────────────────────────────────────────────────────────
    //  Send message
    // ─────────────────────────────────────────────────────────
    private async void OnSendClicked(object sender, EventArgs e)
    {
        if (_isAiReplying) return;

        var text = MessageEntry.Text?.Trim() ?? string.Empty;
        if (string.IsNullOrEmpty(text) && _attachments.Count == 0) return;
        if (string.IsNullOrEmpty(text)) text = "(See attached file)";

        MessageEntry.Text = string.Empty;
        SetSendLocked(true);
        RemoveCurrentSuggestionBlock();

        // Snapshot and clear pending attachments
        var attachmentsCopy = new List<AiAttachment>(_attachments);
        _attachments.Clear();
        AttachmentContainer.Children.Clear();
        AttachmentBar.IsVisible = false;

        await AppendUserBubble(text, attachmentsCopy);
        await ScrollToBottomAsync();

        _history.Add(new ChatTurn { Role = "user", Content = text });

        var (reply, error) = await CallAiWithTypingIndicator(text, attachmentsCopy);

        if (error != null)
            await AppendAiBubble($"⚠️ {error}", isError: true);
        else
        {
            _history.Add(new ChatTurn { Role = "assistant", Content = reply });
            await AppendAiBubble(reply);

            // ── Persist to backend via Spring Boot API ─────────
            _ = Task.Run(async () =>
            {
                try
                {
                    // 必须使用 users.id（数据库主键），不能用 UID 字符串
                    var userDbId = Preferences.Get("current_user_db_id", 0L);

                    if (userDbId <= 0)
                    {
                        Debug.WriteLine("[ChatApi] Save skipped: current_user_db_id is missing or invalid.");
                        return;
                    }

                    // First message → create topic
                    _currentTopicId = await _chatApi.EnsureTopicAsync(
                        userDbId, _currentTopicId, text);

                    // Save user message
                    await _chatApi.SaveMessageAsync(
                        _currentTopicId, userDbId, "user", text);

                    // Save assistant reply
                    await _chatApi.SaveMessageAsync(
                        _currentTopicId, userDbId, "assistant", reply);
                }
                catch (Exception ex)
                {
                    Debug.WriteLine($"[ChatApi] Save failed: {ex.Message}");
                }
            });
        }

        SetSendLocked(false);
        AppendSuggestionBlock();
        await ScrollToBottomAsync();
    }

    // Show typing indicator → call API → remove indicator
    private async Task<(string reply, string? error)> CallAiWithTypingIndicator(
        string text, List<AiAttachment> attachments)
    {
        var modelLabel = _currentModel switch
        {
            AiModel.DeepSeek => "DeepSeek",
            AiModel.Doubao => "Doubao",
            AiModel.Qianwen => "Qwen",
            _ => "AI"
        };

        var typingLabel = new Label
        {
            Text = $"{modelLabel} is typing…",
            FontSize = 13,
            TextColor = Color.FromArgb("#8888A0"),
            Margin = new Thickness(54, 0, 0, 0)
        };
        MessageContainer.Add(typingLabel);
        await ScrollToBottomAsync();

        var result = await _aiSvc.SendAsync(_currentModel, text, _history, attachments);

        MessageContainer.Remove(typingLabel);
        return result;
    }

    // ─────────────────────────────────────────────────────────
    //  Suggestion chips
    // ─────────────────────────────────────────────────────────
    private void AppendSuggestionBlock()
    {
        RemoveCurrentSuggestionBlock();

        var block = new VerticalStackLayout { Spacing = 8 };
        block.Add(new Label
        {
            Text = "You can try:",
            FontSize = 13,
            TextColor = Color.FromArgb("#8888A0"),
            Margin = new Thickness(8, 0, 0, 0)
        });

        // FIX 4: FlexLayout properties — use fully-qualified names to avoid
        //        any ambiguity with MAUI's own namespace imports
        var chips = new FlexLayout
        {
            Wrap = Microsoft.Maui.Layouts.FlexWrap.Wrap,
            JustifyContent = Microsoft.Maui.Layouts.FlexJustify.Start,
            AlignItems = Microsoft.Maui.Layouts.FlexAlignItems.Start,
            Direction = Microsoft.Maui.Layouts.FlexDirection.Row,
            Margin = new Thickness(0, 4, 0, 0)
        };

        foreach (var s in Suggestions)
            chips.Add(BuildSuggestionChip(s));

        block.Add(chips);
        _currentSuggestionBlock = block;
        MessageContainer.Add(block);
    }

    private void RemoveCurrentSuggestionBlock()
    {
        if (_currentSuggestionBlock == null) return;
        MessageContainer.Remove(_currentSuggestionBlock);
        _currentSuggestionBlock = null;
    }

    private Border BuildSuggestionChip(string text)
    {
        var chip = new Border
        {
            BackgroundColor = Colors.White,
            Stroke = new SolidColorBrush(Color.FromArgb("#D0C8F0")),
            StrokeThickness = 1.5,
            Padding = new Thickness(12, 8),
            Margin = new Thickness(0, 0, 8, 8),
            MaximumWidthRequest = 170,
            StrokeShape = new RoundRectangle { CornerRadius = new CornerRadius(12) },
            Content = new Label
            {
                Text = text,
                FontSize = 13,
                TextColor = Color.FromArgb("#4A3F8C"),
                LineBreakMode = LineBreakMode.WordWrap
            }
        };

        chip.GestureRecognizers.Add(new TapGestureRecognizer
        {
            CommandParameter = text,
            Command = new Command<string>(param =>
            {
                if (_isAiReplying) return;
                MessageEntry.Text = param;
                OnSendClicked(this, EventArgs.Empty);
            })
        });

        return chip;
    }

    // ─────────────────────────────────────────────────────────
    //  Clear chat
    // ─────────────────────────────────────────────────────────
    private async void OnClearChatTapped(object sender, TappedEventArgs e)
    {
        bool confirm = await DisplayAlertAsync(
            "Clear Chat", "Clear all messages and history?", "Clear", "Cancel");
        if (!confirm) return;

        // Keep only the static welcome bubble at index 0
        while (MessageContainer.Count > 1)
            MessageContainer.RemoveAt(MessageContainer.Count - 1);

        _history.Clear();
        _currentTopicId = 0;   // reset — next send will create a fresh topic
        _currentSuggestionBlock = null;
        AppendSuggestionBlock();
    }

    // ─────────────────────────────────────────────────────────
    //  Bubble builders
    // ─────────────────────────────────────────────────────────
    private Task AppendUserBubble(string text, List<AiAttachment>? attachments = null)
    {
        var username = Preferences.Get("current_username", "Me");
        var contentStack = new VerticalStackLayout { Spacing = 4 };

        // Attachment badges above the text bubble
        if (attachments?.Count > 0)
        {
            var badgeRow = new HorizontalStackLayout { Spacing = 6 };
            foreach (var att in attachments)
                badgeRow.Add(new Border
                {
                    BackgroundColor = Color.FromArgb("#E94560"),
                    StrokeThickness = 0,
                    Padding = new Thickness(8, 4),
                    StrokeShape = new RoundRectangle { CornerRadius = new CornerRadius(8) },
                    Content = new Label
                    {
                        Text = (att.IsImage ? "🖼 " : "📎 ") + att.FileName,
                        FontSize = 11,
                        TextColor = Colors.White
                    }
                });
            contentStack.Add(badgeRow);
        }

        contentStack.Add(new Border
        {
            BackgroundColor = Color.FromArgb("#1A1A2E"),
            StrokeThickness = 0,
            Padding = new Thickness(14, 10),
            HorizontalOptions = LayoutOptions.End,
            MaximumWidthRequest = BubbleMaxWidth,
            StrokeShape = new RoundRectangle { CornerRadius = new CornerRadius(18, 4, 18, 18) },
            Shadow = new Shadow
            {
                Brush = new SolidColorBrush(Color.FromArgb("#30000000")),
                Offset = new Point(0, 2),
                Radius = 8
            },
            Content = new Label
            {
                Text = text,
                TextColor = Colors.White,
                FontSize = 15,
                LineHeight = 1.5
            }
        });

        var wrapper = new VerticalStackLayout
        {
            Spacing = 4,
            HorizontalOptions = LayoutOptions.End
        };
        wrapper.Add(new Label
        {
            Text = username,
            FontSize = 12,
            TextColor = Color.FromArgb("#8888A0"),
            HorizontalOptions = LayoutOptions.End,
            Margin = new Thickness(0, 0, 4, 0)
        });
        wrapper.Add(contentStack);

        var avatar = new Border
        {
            BackgroundColor = Color.FromArgb("#E94560"),
            WidthRequest = 40,
            HeightRequest = 40,
            StrokeThickness = 0,
            VerticalOptions = LayoutOptions.Start,
            StrokeShape = new Ellipse(),
            Content = new Label
            {
                Text = "Me",
                FontSize = 11,
                FontAttributes = FontAttributes.Bold,
                TextColor = Colors.White,
                HorizontalOptions = LayoutOptions.Center,
                VerticalOptions = LayoutOptions.Center
            }
        };

        var row = new Grid
        {
            ColumnDefinitions =
            {
                new ColumnDefinition(GridLength.Star),
                new ColumnDefinition(GridLength.Auto),
                new ColumnDefinition(GridLength.Auto)
            },
            ColumnSpacing = 10
        };
        Grid.SetColumn(wrapper, 1);
        Grid.SetColumn(avatar, 2);
        row.Add(wrapper);
        row.Add(avatar);

        MessageContainer.Add(row);
        return Task.CompletedTask;
    }

    private Task AppendAiBubble(string text, bool isError = false)
    {
        var modelLabel = _currentModel switch
        {
            AiModel.DeepSeek => "DeepSeek",
            AiModel.Doubao => "Doubao",
            AiModel.Qianwen => "Qwen",
            _ => "AI"
        };

        var avatar = new Border
        {
            BackgroundColor = Color.FromArgb("#1A1A2E"),
            WidthRequest = 40,
            HeightRequest = 40,
            StrokeThickness = 0,
            VerticalOptions = LayoutOptions.Start,
            StrokeShape = new Ellipse(),
            Content = new Label
            {
                Text = "AI",
                FontSize = 11,
                FontAttributes = FontAttributes.Bold,
                TextColor = Colors.White,
                HorizontalOptions = LayoutOptions.Center,
                VerticalOptions = LayoutOptions.Center
            }
        };

        var bubble = new Border
        {
            BackgroundColor = isError ? Color.FromArgb("#FFF0F0") : Colors.White,
            Stroke = new SolidColorBrush(Color.FromArgb("#E8E4F0")),
            StrokeThickness = 1,
            Padding = new Thickness(14, 12),
            MaximumWidthRequest = BubbleMaxWidth,
            HorizontalOptions = LayoutOptions.Start,
            StrokeShape = new RoundRectangle { CornerRadius = new CornerRadius(4, 18, 18, 18) },
            Shadow = new Shadow
            {
                Brush = new SolidColorBrush(Color.FromArgb("#20000000")),
                Offset = new Point(0, 2),
                Radius = 8
            },
            Content = new Label
            {
                Text = text,
                TextColor = isError ? Color.FromArgb("#E94560") : Color.FromArgb("#1A1A2E"),
                FontSize = 15,
                LineHeight = 1.5
            }
        };

        var wrapper = new VerticalStackLayout
        {
            Spacing = 4,
            HorizontalOptions = LayoutOptions.Start
        };
        wrapper.Add(new Label
        {
            Text = modelLabel,
            FontSize = 12,
            TextColor = Color.FromArgb("#8888A0"),
            Margin = new Thickness(4, 0, 0, 0)
        });
        wrapper.Add(bubble);

        var row = new Grid
        {
            ColumnDefinitions =
            {
                new ColumnDefinition(GridLength.Auto),
                new ColumnDefinition(GridLength.Star)
            },
            ColumnSpacing = 10
        };
        Grid.SetColumn(avatar, 0);
        Grid.SetColumn(wrapper, 1);
        row.Add(avatar);
        row.Add(wrapper);

        MessageContainer.Add(row);
        return Task.CompletedTask;
    }

    // ─────────────────────────────────────────────────────────
    //  Utility helpers
    // ─────────────────────────────────────────────────────────
    private void SetSendLocked(bool locked)
    {
        _isAiReplying = locked;
        SendButton.BackgroundColor = locked
            ? Color.FromArgb("#888888")
            : Color.FromArgb("#1A1A2E");
        MessageEntry.IsEnabled = !locked;
    }

    private async Task ScrollToBottomAsync()
    {
        await Task.Delay(60);
        await ChatScrollView.ScrollToAsync(
            0, ChatScrollView.ContentSize.Height, animated: true);
    }
}
