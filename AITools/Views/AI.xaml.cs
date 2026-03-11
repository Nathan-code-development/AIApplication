using Microsoft.Maui.Controls.Shapes;

namespace AITools.Views;

public partial class AI : ContentPage
{
    private bool _isAiReplying = false;
    private View? _currentSuggestionBlock = null;

    private static readonly string[] Suggestions =
    {
        "What's the weather like today?",
        "How much money does a person need to earn in a lifetime?"
    };

    // Maximum bubble width: 65% of the screen width, adaptive for mobile phones and tablets
    private double BubbleMaxWidth => DeviceDisplay.MainDisplayInfo.Width
        / DeviceDisplay.MainDisplayInfo.Density * 0.65;

    public AI()
    {
        InitializeComponent();
        Loaded += (_, _) => AppendSuggestionBlock();
    }

    // Sending logic
    private async void OnSendClicked(object sender, EventArgs e)
    {
        if (_isAiReplying) return;

        string text = MessageEntry.Text?.Trim() ?? string.Empty;
        if (string.IsNullOrEmpty(text)) return;

        MessageEntry.Text = string.Empty;
        SetSendLocked(true);
        RemoveCurrentSuggestionBlock();

        await AppendUserBubble(text);
        await ScrollToBottomAsync();

        await SimulateAiReply("Received! What you said is：「" + text + "」。The AI function is about to be integrated. Please stay tuned. ✨");

        SetSendLocked(false);
        AppendSuggestionBlock();
        await ScrollToBottomAsync();
    }

    // Suggested card click
    private async void OnSuggestionTapped(object sender, TappedEventArgs e)
    {
        if (_isAiReplying) return;

        string suggestion = e.Parameter as string ?? string.Empty;
        if (string.IsNullOrEmpty(suggestion)) return;

        SetSendLocked(true);
        RemoveCurrentSuggestionBlock();

        await AppendUserBubble(suggestion);
        await ScrollToBottomAsync();

        await SimulateAiReply("What you are asking about is「" + suggestion + "」，the AI function is about to be integrated. ✨");

        SetSendLocked(false);
        AppendSuggestionBlock();
        await ScrollToBottomAsync();
    }

    // Lock / Unlock Send
    private void SetSendLocked(bool locked)
    {
        _isAiReplying = locked;
        SendButton.BackgroundColor = locked
            ? Color.FromArgb("#888888")
            : Color.FromArgb("#1A1A2E");
        MessageEntry.IsEnabled = !locked;
    }

    // Suggestion Card Block
    private void AppendSuggestionBlock()
    {
        RemoveCurrentSuggestionBlock();

        var block = new VerticalStackLayout { Spacing = 8 };
        block.Add(new Label
        {
            Text = "you can try：",
            FontSize = 13,
            TextColor = Color.FromArgb("#8888A0"),
            Margin = new Thickness(8, 0, 0, 0)
        });

        var chips = new HorizontalStackLayout
        {
            Spacing = 10,
            HorizontalOptions = LayoutOptions.Center
        };

        foreach (var s in Suggestions)
            chips.Add(BuildSuggestionChip(s));

        block.Add(chips);
        _currentSuggestionBlock = block;
        MessageContainer.Add(block);
    }

    private void RemoveCurrentSuggestionBlock()
    {
        if (_currentSuggestionBlock != null)
        {
            MessageContainer.Remove(_currentSuggestionBlock);
            _currentSuggestionBlock = null;
        }
    }

    private Border BuildSuggestionChip(string text)
    {
        var chip = new Border
        {
            BackgroundColor = Colors.White,
            Stroke = new SolidColorBrush(Color.FromArgb("#D0C8F0")),
            StrokeThickness = 1.5,
            Padding = new Thickness(14, 10),
            MaximumWidthRequest = 160,
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
            Command = new Command<string>(async (param) =>
            {
                if (_isAiReplying) return;
                SetSendLocked(true);
                RemoveCurrentSuggestionBlock();
                await AppendUserBubble(param);
                await ScrollToBottomAsync();
                await SimulateAiReply("What you are asking about is「" + param + "」，the AI function is about to be integrated. ✨");
                SetSendLocked(false);
                AppendSuggestionBlock();
                await ScrollToBottomAsync();
            })
        });

        return chip;
    }

    // User Bubble（Right）
    private Task AppendUserBubble(string text)
    {
        var bubble = new Border
        {
            BackgroundColor = Color.FromArgb("#1A1A2E"),
            StrokeThickness = 0,
            Padding = new Thickness(14, 10),
            // ✅ Use the screen ratio instead of a fixed value for automatic adaptation of mobile phones/tablets
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
        };

        var nameLabel = new Label
        {
            Text = "Me",
            FontSize = 12,
            TextColor = Color.FromArgb("#8888A0"),
            HorizontalOptions = LayoutOptions.End,
            Margin = new Thickness(0, 0, 4, 0)
        };

        // ✅ The bubble content area (name + bubble) is on the right.
        var wrapper = new VerticalStackLayout
        {
            Spacing = 4,
            HorizontalOptions = LayoutOptions.End   // ← Key point: The entire wrapper should be positioned to the right.
        };
        wrapper.Add(nameLabel);
        wrapper.Add(bubble);

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
                Text = "我",
                FontSize = 13,
                FontAttributes = FontAttributes.Bold,
                TextColor = Colors.White,
                HorizontalOptions = LayoutOptions.Center,
                VerticalOptions = LayoutOptions.Center
            }
        };

        // ✅ Use only two columns: [Flexible blank area *] [Bubble content Auto] [Avatar Auto]
        var row = new Grid
        {
            ColumnDefinitions =
            {
                new ColumnDefinition(GridLength.Star),  // Left margin is empty. Push the content to the right.
                new ColumnDefinition(GridLength.Auto),  // bubble
                new ColumnDefinition(GridLength.Auto)   // head image
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

    // AI bubble (on the left)
    private async Task SimulateAiReply(string text)
    {
        var typingLabel = new Label
        {
            Text = "AI be typing…",
            FontSize = 13,
            TextColor = Color.FromArgb("#8888A0"),
            Margin = new Thickness(54, 0, 0, 0)
        };
        MessageContainer.Add(typingLabel);
        await ScrollToBottomAsync();

        await Task.Delay(900);
        MessageContainer.Remove(typingLabel);

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
            BackgroundColor = Colors.White,
            Stroke = new SolidColorBrush(Color.FromArgb("#E8E4F0")),
            StrokeThickness = 1,
            Padding = new Thickness(14, 12),
            // ✅ Also use screen aspect ratio adaptation
            MaximumWidthRequest = BubbleMaxWidth,
            HorizontalOptions = LayoutOptions.Start,  // ← The bubble is on the left.
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
                TextColor = Color.FromArgb("#1A1A2E"),
                FontSize = 15,
                LineHeight = 1.5
            }
        };

        // ✅ The AI name labels are also on the left.
        var wrapper = new VerticalStackLayout
        {
            Spacing = 4,
            HorizontalOptions = LayoutOptions.Start  // ← key point
        };
        wrapper.Add(new Label
        {
            Text = "AI Assistant",
            FontSize = 12,
            TextColor = Color.FromArgb("#8888A0"),
            Margin = new Thickness(4, 0, 0, 0)
        });
        wrapper.Add(bubble);

        // ✅ Use only two columns: [Avatar Auto] [Bubble Content *] —— Remove the empty column on the right
        var row = new Grid
        {
            ColumnDefinitions =
            {
                new ColumnDefinition(GridLength.Auto),  // head image
                new ColumnDefinition(GridLength.Star)   // Bubble area, remaining space, but the bubble itself is limited by Start + MaxWidth in terms of width.
            },
            ColumnSpacing = 10
        };

        Grid.SetColumn(avatar, 0);
        Grid.SetColumn(wrapper, 1);
        row.Add(avatar);
        row.Add(wrapper);

        MessageContainer.Add(row);
        await ScrollToBottomAsync();
    }

    // Scroll to the bottom
    private async Task ScrollToBottomAsync()
    {
        await Task.Delay(50);
        await ChatScrollView.ScrollToAsync(0, ChatScrollView.ContentSize.Height, animated: true);
    }
}