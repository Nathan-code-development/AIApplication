using AITools.Services;
using Microsoft.Maui.Controls.Shapes;
using System.Buffers.Text;
using System.Diagnostics;
using IOPath = System.IO.Path;

namespace AITools.Views;

public partial class AI : ContentPage
{
    // Static "mailbox" set by Myself/AllTopicsPage before
    // Shell.Current.GoToAsync("//AI") is called.
    // AI.OnAppearing reads and clears it.
    public static long PendingTopicId = 0;
    public static string PendingTopicTitle = string.Empty;

    // Services 
    private readonly AiApiService _aiSvc = new();
    private readonly ChatApiService _chatApi = new();

    // State 
    private bool _isAiReplying = false;
    private AiModel _currentModel = AiModel.DeepSeek;
    private View? _currentSuggestionBlock = null;

    // Chat persistence 
    private long _currentTopicId = 0;
    private readonly List<ChatTurn> _history = [];
    private readonly List<AiAttachment> _attachments = []; 
    private const string BaseUrl = "http://121.40.144.4:380";
    private static readonly HttpClient _http = new()
    {
        Timeout = TimeSpan.FromSeconds(15)
    };

    // Track whether we already loaded history for the current topic 
    private long _loadedTopicId = 0;

    private static readonly string[] AllSuggestions =
{
    // Daily life
    "What's the weather like today?",
    "Recommend a simple breakfast recipe",
    "How to relieve work stress?",
    "What to do when I can't sleep at night?",
    "How to improve memory?",
    "How much water should I drink per day?",
    "How to relax my neck after sitting for a long time?",
    "Where is a good weekend getaway?",
    "How to build a habit of waking up early?",
    "Share a money-saving tip",

    // Learning & skills
    "How to learn a new language quickly?",
    "Recommend a book to improve logical thinking",
    "How to take effective reading notes?",
    "How to overcome procrastination?",
    "Easily distracted while studying, what to do?",
    "How to prepare for a speech?",
    "Recommend an online learning platform",
    "How to improve writing skills?",
    "Best way to memorize English words",
    "How to make a realistic study plan?",

    // Technology & tools
    "Recommend a good note-taking app",
    "How to protect my privacy online?",
    "Will AI replace human jobs?",
    "How to take professional photos with a phone?",
    "Recommend a few useful WeChat mini programs",
    "How to organize my computer desktop files?",
    "How to quickly find a lost phone?",
    "What are some practical smart home devices?",
    "How to spot an online rumor?",
    "How to back up important data on my phone?",

    // Health & fitness
    "How much exercise is healthy per day?",
    "How to fix rounded shoulders and hunched back?",
    "Recommend a beginner-friendly exercise",
    "How to relieve eye strain?",
    "What should I eat when trying to lose weight?",
    "How to tell if I'm dehydrated?",
    "Office stretching routine for desk workers",
    "How to improve sleep quality?",
    "What could cause frequent headaches?",
    "How to maintain emotional stability?",

    // Social & relationships
    "How to start a conversation with a stranger?",
    "How to resolve a conflict with a friend?",
    "How to say no without hurting feelings?",
    "How to overcome social anxiety?",
    "How to maintain a long-term friendship?",
    "How to express gratitude sincerely?",
    "How to respond to criticism constructively?",
    "How to tell if someone is worth trusting?",
    "How to communicate better in a team?",
    "Share a tip to strengthen an intimate relationship"
};

    private double BubbleMaxWidth =>
        DeviceDisplay.MainDisplayInfo.Width /
        DeviceDisplay.MainDisplayInfo.Density * 0.65;

    // Constructor (single, parameterless — required by Shell)
    public AI()
    {
        InitializeComponent();
        Loaded += (_, _) => AppendSuggestionBlock();
    }

    // OnAppearing — called every time the AI tab becomes active
    protected override async void OnAppearing()
    {
        base.OnAppearing();

        if (PendingTopicId != 0 && PendingTopicId != _loadedTopicId)
        {
            long topicId = PendingTopicId;
            string title = PendingTopicTitle;

            PendingTopicId = 0;
            PendingTopicTitle = string.Empty;

            await OpenTopicAsync(topicId, title);
        }
    }

    // OpenTopicAsync — reset UI then load history
    private async Task OpenTopicAsync(long topicId, string title)
    {
        while (MessageContainer.Count > 1)
            MessageContainer.RemoveAt(MessageContainer.Count - 1);

        _history.Clear();
        _currentSuggestionBlock = null;
        _currentTopicId = topicId;
        _loadedTopicId = topicId;

        HeaderModelLabel.Text = title;

        var loadingLabel = new Label
        {
            Text = "Loading conversation…",
            FontSize = 13,
            TextColor = Color.FromArgb("#8888A0"),
            HorizontalOptions = LayoutOptions.Center,
            Margin = new Thickness(0, 8)
        };
        MessageContainer.Add(loadingLabel);

        try
        {
            await ScrollToBottomAsync();
        }
        catch { /* Ignore failed scroll */ }

        try
        {
            var messages = await _chatApi.GetMessagesAsync(topicId);
            MessageContainer.Remove(loadingLabel);

            if (messages.Count == 0)
            {
                AppendSuggestionBlock();
                return;
            }

            foreach (var msg in messages)
            {
                if (msg.RoleLabel == "user")
                {
                    await AppendUserBubble(msg.Content);
                    _history.Add(new ChatTurn { Role = "user", Content = msg.Content });
                }
                else
                {
                    await AppendAiBubble(msg.Content);
                    _history.Add(new ChatTurn { Role = "assistant", Content = msg.Content });
                }
            }

            MessageContainer.Add(new Label
            {
                Text = " continue the conversation ",
                FontSize = 11,
                TextColor = Color.FromArgb("#B0A8C8"),
                HorizontalOptions = LayoutOptions.Center,
                HorizontalTextAlignment = TextAlignment.Center,
                Margin = new Thickness(0, 8)
            });

            AppendSuggestionBlock();
            await ScrollToBottomAsync();
        }
        catch (Exception ex)
        {
            MessageContainer.Remove(loadingLabel);
            await AppendAiBubble($"⚠️ Could not load conversation history: {ex.Message}", isError: true);
            AppendSuggestionBlock();
            Debug.WriteLine($"[AI] OpenTopicAsync error: {ex.Message}");
        }
    }

    // Model tab switching
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

        if (_loadedTopicId == 0)
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

        if (tab.Content is HorizontalStackLayout hsl && hsl.Count >= 2
            && hsl[1] is Label lbl)
            lbl.TextColor = active ? Colors.White : Color.FromArgb("#4A3F8C");
    }

    // Attach image
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
            var results = await MediaPicker.Default.PickPhotosAsync(
                new MediaPickerOptions { Title = "Select an image" });
            var file = results?.FirstOrDefault();
            if (file == null) return;

            using var stream = await file.OpenReadAsync();
            using var ms = new MemoryStream();
            await stream.CopyToAsync(ms);

            var ext = IOPath.GetExtension(file.FileName).ToLowerInvariant();
            var mimeType = ext switch
            {
                ".png" => "image/png",
                ".gif" => "image/gif",
                ".webp" => "image/webp",
                _ => "image/jpeg"
            };
            _attachments.Add(new AiAttachment { FileName = file.FileName, MimeType = mimeType, Data = ms.ToArray() });
            AddAttachmentChip(file.FileName, "🖼");
        }
        catch (Exception ex)
        {
            await DisplayAlertAsync("Error", $"Could not attach image: {ex.Message}", "OK");
        }
    }

    // Attach file
    private async void OnAttachFileTapped(object sender, TappedEventArgs e)
    {
        if (_isAiReplying) return;
        try
        {
            var result = await FilePicker.Default.PickAsync(new PickOptions
            {
                PickerTitle = "Select a file",
                FileTypes = new FilePickerFileType(new Dictionary<DevicePlatform, IEnumerable<string>>
                {
                    { DevicePlatform.Android,     ["*/*"] },
                    { DevicePlatform.iOS,         ["public.content"] },
                    { DevicePlatform.WinUI,       ["*"] },
                    { DevicePlatform.MacCatalyst, ["public.content"] }
                })
            });
            if (result == null) return;

            using var stream = await result.OpenReadAsync();
            using var ms = new MemoryStream();
            await stream.CopyToAsync(ms);

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
            _attachments.Add(new AiAttachment { FileName = result.FileName, MimeType = mimeType, Data = ms.ToArray() });
            AddAttachmentChip(result.FileName, "📎");
        }
        catch (Exception ex)
        {
            await DisplayAlertAsync("Error", $"Could not attach file: {ex.Message}", "OK");
        }
    }

    // Attachment chip
    private void AddAttachmentChip(string fileName, string icon)
    {
        AttachmentBar.IsVisible = true;
        var displayName = fileName.Length > 16 ? fileName[..13] + "…" : fileName;

        var chip = new Border
        {
            BackgroundColor = Color.FromArgb("#1A1A2E"),
            StrokeThickness = 0,
            Padding = new Thickness(10, 6),
            StrokeShape = new RoundRectangle { CornerRadius = new CornerRadius(12) }
        };
        var chipContent = new HorizontalStackLayout { Spacing = 6 };
        chipContent.Add(new Label { Text = icon, FontSize = 13 });
        chipContent.Add(new Label { Text = displayName, FontSize = 12, TextColor = Colors.White, VerticalOptions = LayoutOptions.Center });

        int idx = _attachments.Count - 1;
        var removeBtn = new Label { Text = " ✕", FontSize = 12, TextColor = Color.FromArgb("#E94560"), VerticalOptions = LayoutOptions.Center };
        removeBtn.GestureRecognizers.Add(new TapGestureRecognizer
        {
            Command = new Command(() =>
            {
                if (idx >= 0 && idx < _attachments.Count) _attachments.RemoveAt(idx);
                AttachmentContainer.Remove(chip);
                if (AttachmentContainer.Count == 0) AttachmentBar.IsVisible = false;
            })
        });
        chipContent.Add(removeBtn);
        chip.Content = chipContent;
        AttachmentContainer.Add(chip);
    }

    // Send message
    private async void OnSendClicked(object sender, EventArgs e)
    {
        if (_isAiReplying) return;
        var text = MessageEntry.Text?.Trim() ?? string.Empty;
        if (string.IsNullOrEmpty(text) && _attachments.Count == 0) return;
        if (string.IsNullOrEmpty(text)) text = "(See attached file)";

        MessageEntry.Text = string.Empty;
        SetSendLocked(true);
        RemoveCurrentSuggestionBlock();

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

            _ = Task.Run(async () =>
            {
                try
                {
                    var userDbId = Preferences.Get("current_user_db_id", 0L);
                    if (userDbId <= 0) return;
                    _currentTopicId = await _chatApi.EnsureTopicAsync(userDbId, _currentTopicId, text);
                    if (_loadedTopicId == 0) _loadedTopicId = _currentTopicId;
                    await _chatApi.SaveMessageAsync(_currentTopicId, userDbId, "user", text);
                    await _chatApi.SaveMessageAsync(_currentTopicId, userDbId, "assistant", reply);
                }
                catch (Exception ex) { Debug.WriteLine($"[ChatApi] Save failed: {ex.Message}"); }
            });
        }

        SetSendLocked(false);
        AppendSuggestionBlock();
        await ScrollToBottomAsync();
    }

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

    private View BuildSuggestionItem(string text)
    {
        var label = new Label
        {
            Text = text,
            FontSize = 14,
            TextColor = Color.FromArgb("#4A3F8C"),
            LineBreakMode = LineBreakMode.WordWrap,
            HorizontalTextAlignment = TextAlignment.Center,
            VerticalTextAlignment = TextAlignment.Center
        };

        var item = new Border
        {
            BackgroundColor = Colors.White,
            Stroke = new SolidColorBrush(Color.FromArgb("#D0C8F0")),
            StrokeThickness = 1.5,
            Padding = new Thickness(14, 12),
            HorizontalOptions = LayoutOptions.Fill,
            StrokeShape = new RoundRectangle
            {
                CornerRadius = new CornerRadius(14)
            },
            Content = label
        };

        item.GestureRecognizers.Add(new TapGestureRecognizer
        {
            CommandParameter = text,
            Command = new Command<string>(p =>
            {
                if (_isAiReplying) return;
                MessageEntry.Text = p;
                OnSendClicked(this, EventArgs.Empty);
            })
        });

        var grid = new Grid
        {
            ColumnDefinitions =
        {
            new ColumnDefinition(new GridLength(0.08, GridUnitType.Star)),
            new ColumnDefinition(new GridLength(0.84, GridUnitType.Star)),
            new ColumnDefinition(new GridLength(0.08, GridUnitType.Star)),
        }
        };

        // 添加子视图并设置其列位置
        grid.Children.Add(item);
        Grid.SetColumn(item, 1);  // 放在第2列（索引1）
        Grid.SetRow(item, 0);     // 放在第1行

        return grid;
    }

    // 替换原来的 AppendSuggestionBlock 方法
    private void AppendSuggestionBlock()
    {
        RemoveCurrentSuggestionBlock();

        // Randomly pick 4 non-duplicate suggestions
        var random = new Random();
        var selectedIndices = new HashSet<int>();
        while (selectedIndices.Count < 4 && selectedIndices.Count < AllSuggestions.Length)
        {
            selectedIndices.Add(random.Next(AllSuggestions.Length));
        }
        var selectedSuggestions = selectedIndices.Select(i => AllSuggestions[i]).ToList();

        var block = new VerticalStackLayout { Spacing = 8 };
        block.Add(new Label
        {
            Text = "You can try:",
            FontSize = 13,
            TextColor = Color.FromArgb("#8888A0"),
            Margin = new Thickness(8, 0, 0, 0)
        });

        foreach (var s in selectedSuggestions)
        {
            block.Add(BuildSuggestionItem(s));
        }

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
            Content = new Label { Text = text, FontSize = 13, TextColor = Color.FromArgb("#4A3F8C"), LineBreakMode = LineBreakMode.WordWrap }
        };
        chip.GestureRecognizers.Add(new TapGestureRecognizer
        {
            CommandParameter = text,
            Command = new Command<string>(p =>
            {
                if (_isAiReplying) return;
                MessageEntry.Text = p;
                OnSendClicked(this, EventArgs.Empty);
            })
        });
        return chip;
    }

    // New Chat - starts a fresh conversation
    private async void OnNewChatTapped(object sender, TappedEventArgs e)
    {
        if (_isAiReplying) return;

        bool confirm = await DisplayAlertAsync("New Chat", "Start a new conversation? Current chat will be cleared.", "New", "Cancel");
        if (!confirm) return;

        // Clear pending topic from static mailbox
        PendingTopicId = 0;
        PendingTopicTitle = string.Empty;

        // Clear attachments
        _attachments.Clear();
        AttachmentContainer.Children.Clear();
        AttachmentBar.IsVisible = false;

        // Clear messages but keep the static welcome bubble (index 0)
        while (MessageContainer.Count > 1)
            MessageContainer.RemoveAt(MessageContainer.Count - 1);

        _history.Clear();
        _currentTopicId = 0;
        _loadedTopicId = 0;
        _currentSuggestionBlock = null;

        // Reset header label to current model name
        UpdateModelTabUI(_currentModel);

        // Show suggestion chips
        AppendSuggestionBlock();
        await ScrollToBottomAsync();
    }

    // Clear Chat - clears all messages and history
    private async void OnClearChatTapped(object sender, TappedEventArgs e)
    {
        bool confirm = await DisplayAlertAsync("Clear Chat", "Clear all messages in this conversation?", "Clear", "Cancel");
        if (!confirm) return;

        try
        {
            // 1. If the current topic already exists, call the backend to delete all the messages under that topic.
            if (_currentTopicId > 0)
            {
                bool success = await _chatApi.DeleteMessagesByTopicIdAsync(_currentTopicId);
                await _http.GetAsync($"{BaseUrl}/Topics/deleteById?id={_currentTopicId}");
                if (!success)
                    throw new Exception("Failed to delete messages on server.");
            }

            // 2. Clear local attachments
            _attachments.Clear();
            AttachmentContainer.Children.Clear();
            AttachmentBar.IsVisible = false;

            // 3. Clear the message container (retain the static welcome bubble at index 0)
            while (MessageContainer.Count > 1)
                MessageContainer.RemoveAt(MessageContainer.Count - 1);

            // 4. Reset the local history records and status
            _history.Clear();
            _currentSuggestionBlock = null;

            // 5. Restore the title to be the name of the current model (instead of the topic title)
            HeaderModelLabel.Text = _currentModel switch
            {
                AiModel.DeepSeek => "DeepSeek Chat",
                AiModel.Doubao => "Doubao AI",
                AiModel.Qianwen => "Qwen AI",
                _ => "AI Chatbox"
            };

            // Note: Do not clear _currentTopicId and _loadedTopicId. Subsequent new messages will still be saved to the same topic.

            // 6. Re-display the suggestion block
            AppendSuggestionBlock();
            await ScrollToBottomAsync();

            await DisplayAlertAsync("Success", "Conversation cleared.", "OK");
        }
        catch (Exception ex)
        {
            await DisplayAlertAsync("Error", $"Failed to clear: {ex.Message}", "OK");
        }
    }

    private View BuildDefaultAvatar()
    {
        return new Label
        {
            Text = "Me",
            FontSize = 11,
            FontAttributes = FontAttributes.Bold,
            TextColor = Colors.White,
            HorizontalOptions = LayoutOptions.Center,
            VerticalOptions = LayoutOptions.Center
        };
    }

    // Bubble builders
    private Task AppendUserBubble(string text, List<AiAttachment>? attachments = null)
    {
        var username = Preferences.Get("current_username", "Me");
        //var avatarFileName = Preferences.Get("avatarFileName", string.Empty);


        var contentStack = new VerticalStackLayout { Spacing = 4 };

        // ── Attachments ──
        if (attachments?.Count > 0)
        {
            var badgeRow = new HorizontalStackLayout { Spacing = 6 };
            foreach (var att in attachments)
            {
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
            }
            contentStack.Add(badgeRow);
        }

        // ── Message bubble ──
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

        // ── Wrapper ──
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

        // ── Avatar（Key modification points）──
        View avatarContent;

        try
        {
            var avatarUrl = Preferences.Get("avatarUrl", string.Empty);
            //var avatarUrl = UserProfileService.AvatarDownloadUrl(avatarFileName);

            avatarContent = new Image
            {
                Source = ImageSource.FromUri(new Uri(avatarUrl)),
                Aspect = Aspect.AspectFill
            };
        }
        catch
        {
            avatarContent = BuildDefaultAvatar();
        }

        var avatar = new Border
        {
            BackgroundColor = Color.FromArgb("#E94560"),
            WidthRequest = 40,
            HeightRequest = 40,
            StrokeThickness = 0,
            VerticalOptions = LayoutOptions.Start,
            StrokeShape = new Ellipse(),
            Content = avatarContent
        };

        // 👉 关键：强制裁剪成圆形（防止图片溢出）
        avatar.Clip = new EllipseGeometry
        {
            Center = new Point(20, 20),
            RadiusX = 20,
            RadiusY = 20
        };

        // ── Layout ──
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
            Content = new Label { Text = "AI", FontSize = 11, FontAttributes = FontAttributes.Bold, TextColor = Colors.White, HorizontalOptions = LayoutOptions.Center, VerticalOptions = LayoutOptions.Center }
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
            Shadow = new Shadow { Brush = new SolidColorBrush(Color.FromArgb("#20000000")), Offset = new Point(0, 2), Radius = 8 },
            Content = new Label { Text = text, TextColor = isError ? Color.FromArgb("#E94560") : Color.FromArgb("#1A1A2E"), FontSize = 15, LineHeight = 1.5 }
        };

        var wrapper = new VerticalStackLayout { Spacing = 4, HorizontalOptions = LayoutOptions.Start };
        wrapper.Add(new Label { Text = modelLabel, FontSize = 12, TextColor = Color.FromArgb("#8888A0"), Margin = new Thickness(4, 0, 0, 0) });
        wrapper.Add(bubble);

        var row = new Grid
        {
            ColumnDefinitions = { new ColumnDefinition(GridLength.Auto), new ColumnDefinition(GridLength.Star) },
            ColumnSpacing = 10
        };
        Grid.SetColumn(avatar, 0); Grid.SetColumn(wrapper, 1);
        row.Add(avatar); row.Add(wrapper);
        MessageContainer.Add(row);
        return Task.CompletedTask;
    }

    // Utilities
    private void SetSendLocked(bool locked)
    {
        _isAiReplying = locked;
        SendButton.BackgroundColor = locked ? Color.FromArgb("#888888") : Color.FromArgb("#1A1A2E");
        MessageEntry.IsEnabled = !locked;
    }

    private async Task ScrollToBottomAsync()
    {
        await Task.Delay(60);
        if (ChatScrollView != null)
        {
            try
            {
                await ChatScrollView.ScrollToAsync(0, ChatScrollView.ContentSize.Height, animated: true);
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"[Scroll] Failed: {ex.Message}");
            }
        }
    }
}