using AITools.Services;
using Microsoft.Maui.Controls.Shapes;

namespace AITools.Views;

public partial class AllTopicsPage : ContentPage
{
    private readonly ChatApiService _chatApi = new();

    private static readonly (string emoji, string bg)[] TopicStyles =
    {
        ("💬", "#EEF0FF"),
        ("🌟", "#FFF0F3"),
        ("🔍", "#F0FFF4"),
        ("📌", "#FFF8F0"),
        ("💡", "#F5F0FF"),
        ("🎯", "#F0F8FF"),
        ("🚀", "#FFF0FF"),
        ("📝", "#F0FFFF"),
    };

    public AllTopicsPage()
    {
        InitializeComponent();
    }

    protected override void OnAppearing()
    {
        base.OnAppearing();
        _ = LoadTopicsAsync();
    }

    private async Task LoadTopicsAsync()
    {
        LoadingIndicator.IsVisible = true;
        LoadingIndicator.IsRunning = true;
        EmptyState.IsVisible = false;
        TopicsScrollView.IsVisible = false;
        TopicsContainer.Children.Clear();

        var userDbId = Preferences.Get("current_user_db_id", 0L);
        if (userDbId <= 0)
        {
            LoadingIndicator.IsVisible = false;
            EmptyState.IsVisible = true;
            return;
        }

        try
        {
            var topics = await _chatApi.GetTopicsAsync(userDbId);

            LoadingIndicator.IsVisible = false;
            LoadingIndicator.IsRunning = false;

            if (topics == null || topics.Count == 0)
            {
                EmptyState.IsVisible = true;
                return;
            }

            TopicsCountLabel.Text = $"{topics.Count} conversation{(topics.Count == 1 ? "" : "s")}, newest first";
            TopicsScrollView.IsVisible = true;

            for (int i = 0; i < topics.Count; i++)
            {
                var topic = topics[i];
                var style = TopicStyles[i % TopicStyles.Length];

                if (i > 0)
                    TopicsContainer.Children.Add(new BoxView
                    {
                        HeightRequest = 1,
                        Color = Color.FromArgb("#F0EEF8"),
                        Margin = new Thickness(16, 0)
                    });

                TopicsContainer.Children.Add(BuildTopicRow(topic, style.emoji, style.bg));
            }
        }
        catch (Exception ex)
        {
            LoadingIndicator.IsVisible = false;
            EmptyState.IsVisible = true;
            System.Diagnostics.Debug.WriteLine($"[AllTopicsPage] error: {ex.Message}");
        }
    }

    private View BuildTopicRow(TopicDto topic, string emoji, string bgColor)
    {
        var iconBorder = new Border
        {
            BackgroundColor = Color.FromArgb(bgColor),
            WidthRequest = 36,
            HeightRequest = 36,
            StrokeThickness = 0,
            StrokeShape = new RoundRectangle { CornerRadius = new CornerRadius(10) },
            Content = new Label
            {
                Text = emoji,
                FontSize = 17,
                HorizontalOptions = LayoutOptions.Center,
                VerticalOptions = LayoutOptions.Center
            }
        };

        var infoStack = new VerticalStackLayout
        {
            Margin = new Thickness(14, 0, 0, 0),
            VerticalOptions = LayoutOptions.Center,
            Spacing = 3
        };
        infoStack.Add(new Label
        {
            Text = topic.Title,
            FontSize = 15,
            FontAttributes = FontAttributes.Bold,
            TextColor = Color.FromArgb("#1A1A2E"),
            LineBreakMode = LineBreakMode.TailTruncation,
            MaxLines = 2
        });
        infoStack.Add(new Label
        {
            Text = BuildSubtitle(topic),
            FontSize = 12,
            TextColor = Color.FromArgb("#8888A0")
        });

        var chevron = new Label
        {
            Text = "›",
            FontSize = 22,
            TextColor = Color.FromArgb("#B0A8C8"),
            VerticalOptions = LayoutOptions.Center
        };

        var grid = new Grid
        {
            ColumnDefinitions =
            {
                new ColumnDefinition(GridLength.Auto),
                new ColumnDefinition(GridLength.Star),
                new ColumnDefinition(GridLength.Auto)
            },
            Padding = new Thickness(16, 16)
        };
        Grid.SetColumn(iconBorder, 0);
        Grid.SetColumn(infoStack, 1);
        Grid.SetColumn(chevron, 2);
        grid.Add(iconBorder);
        grid.Add(infoStack);
        grid.Add(chevron);

        // ── Tap: set pending topic → switch to AI tab ──
        grid.GestureRecognizers.Add(new TapGestureRecognizer
        {
            Command = new Command(async () =>
            {
                AI.PendingTopicId = topic.Id;
                AI.PendingTopicTitle = topic.Title;

                // Pop back to the main shell first, then switch tab
                await Navigation.PopAsync();
                await Shell.Current.GoToAsync("//AI");
            })
        });

        return grid;
    }

    private static string BuildSubtitle(TopicDto topic)
    {
        var parts = new List<string>();
        if (topic.MessageCount > 0)
            parts.Add($"{topic.MessageCount} messages");

        var dateStr = string.IsNullOrEmpty(topic.UpdatedAt) ? topic.CreatedAt : topic.UpdatedAt;
        if (!string.IsNullOrEmpty(dateStr) && DateTime.TryParse(dateStr, out var dt))
        {
            var elapsed = DateTime.Now - dt;
            if (elapsed.TotalMinutes < 1) parts.Add("just now");
            else if (elapsed.TotalHours < 1) parts.Add($"{(int)elapsed.TotalMinutes}m ago");
            else if (elapsed.TotalDays < 1) parts.Add($"{(int)elapsed.TotalHours}h ago");
            else if (elapsed.TotalDays < 7) parts.Add($"{(int)elapsed.TotalDays}d ago");
            else parts.Add(dt.ToString("MMM d, yyyy"));
        }

        return parts.Count > 0 ? string.Join(" · ", parts) : "Tap to open";
    }

    private async void OnBackTapped(object sender, TappedEventArgs e)
        => await Navigation.PopAsync();
}
