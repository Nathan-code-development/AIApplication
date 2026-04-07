using AITools.Services;
using Microsoft.Maui.Controls.Shapes;

namespace AITools.Views;

public partial class Myself : ContentPage
{
    private readonly ChatApiService _chatApi = new();
    private readonly UserProfileService _profileSvc = new();

    private static readonly (string emoji, string bg)[] TopicStyles =
    {
        ("💬", "#EEF0FF"), ("🌟", "#FFF0F3"), ("🔍", "#F0FFF4"),
        ("📌", "#FFF8F0"), ("💡", "#F5F0FF"), ("🎯", "#F0F8FF"),
    };

    public Myself()
    {
        InitializeComponent();
    }

    
    //  Lifecycle
    
    protected override void OnAppearing()
    {
        base.OnAppearing();
        LoadUserInfo();
        _ = LoadTopicsAsync();
    }

    
    //  Load user info + avatar
    
    private void LoadUserInfo()
    {
        var username = Preferences.Get("current_username", "Unknown User");
        var userId = Preferences.Get("userId", string.Empty);
        var realName = Preferences.Get("userRealName", string.Empty);

        UsernameLabel.Text = string.IsNullOrEmpty(realName) ? username : realName;
        UserIdLabel.Text = string.IsNullOrEmpty(userId) ? "User ID: —" : $"User ID: {userId}";

        // Try to display the cached avatar immediately, then refresh from network
        var cachedFileName = Preferences.Get("avatarFileName", string.Empty);
        var avatarUrl = Preferences.Get("avatarUrl", string.Empty);
        if (!string.IsNullOrEmpty(cachedFileName))
            ShowAvatarFromUrl(UserProfileService.AvatarDownloadUrl(cachedFileName));
        ShowAvatarFromUrl(avatarUrl);
    }

    
    //  Avatar: tap → pick image → upload → bind → display
    
    private async void OnAvatarTapped(object sender, TappedEventArgs e)
    {
        // Prevent double-tap while uploading
        if (AvatarUploadSpinner.IsRunning) return;

        try
        {
            // 1. Let the user pick a photo from the gallery
            var results = await MediaPicker.Default.PickPhotosAsync(
                new MediaPickerOptions { Title = "Choose a profile photo" });

            var file = results?.FirstOrDefault();
            if (file == null) return;

            // 2. Show spinner, dim the avatar
            SetAvatarUploading(true);

            // 3. Open the file stream and upload to the server
            using var stream = await file.OpenReadAsync();

            var (serverFileName, uploadError) =
                await _profileSvc.UploadAvatarAsync(stream, file.FileName);

            if (uploadError != null || string.IsNullOrEmpty(serverFileName))
            {
                SetAvatarUploading(false);
                await DisplayAlertAsync("Upload Failed",
                    uploadError ?? "Server returned no filename.", "OK");
                return;
            }

            // 4. Bind the file name to the user account
            //    addHeadImage takes the custom "UID..." string, not the numeric id
            var uidString = Preferences.Get("userId", string.Empty);
            if (string.IsNullOrEmpty(uidString))
            {
                SetAvatarUploading(false);
                await DisplayAlertAsync("Error", "User ID not found. Please log in again.", "OK");
                return;
            }

            var (bindOk, bindError) =
                await _profileSvc.BindAvatarAsync(uidString, serverFileName);

            if (!bindOk)
            {
                SetAvatarUploading(false);
                await DisplayAlertAsync("Link Failed",
                    bindError ?? "Could not link avatar to account.", "OK");
                return;
            }

            // 5. Persist the filename locally so we can reload it next time
            Preferences.Set("avatarFileName", serverFileName);

            // 6. Display the new avatar
            var imageUrl = UserProfileService.AvatarDownloadUrl(serverFileName);
            ShowAvatarFromUrl(imageUrl);

            SetAvatarUploading(false);
            await DisplayAlertAsync("Success", "Profile photo updated! ✓", "OK");
        }
        catch (Exception ex)
        {
            SetAvatarUploading(false);
            await DisplayAlertAsync("Error", $"Could not update photo: {ex.Message}", "OK");
        }
    }

    // ── Show an avatar from a URL 
    private void ShowAvatarFromUrl(string url)
    {
        try
        {
            AvatarImage.Source = ImageSource.FromUri(new Uri(url));
            AvatarImage.IsVisible = true;
            AvatarPlaceholder.IsVisible = false;
        }
        catch
        {
            // If the URL fails, keep the placeholder
        }
    }

    // ── Toggle uploading state 
    private void SetAvatarUploading(bool uploading)
    {
        AvatarUploadSpinner.IsRunning = uploading;
        AvatarUploadSpinner.IsVisible = uploading;
        // Semi-dim the avatar while uploading
        AvatarBorder.Opacity = uploading ? 0.4 : 1.0;
    }

    
    //  Topics
    
    private async Task LoadTopicsAsync()
    {
        var userDbId = Preferences.Get("current_user_db_id", 0L);

        TopicsLoadingIndicator.IsVisible = true;
        TopicsLoadingIndicator.IsRunning = true;
        TopicsEmptyState.IsVisible = false;
        MoreTopicsRow.IsVisible = false;
        TopicsContainer.Children.Clear();

        if (userDbId <= 0)
        {
            TopicsLoadingIndicator.IsVisible = false;
            TopicsEmptyState.IsVisible = true;
            return;
        }

        try
        {
            var topics = await _chatApi.GetTopicsAsync(userDbId);

            TopicsLoadingIndicator.IsVisible = false;
            TopicsLoadingIndicator.IsRunning = false;

            if (topics == null || topics.Count == 0)
            {
                TopicsEmptyState.IsVisible = true;
                return;
            }

            var preview = topics.Take(3).ToList();
            for (int i = 0; i < preview.Count; i++)
            {
                if (i > 0)
                    TopicsContainer.Children.Add(new BoxView
                    {
                        HeightRequest = 1,
                        Color = Color.FromArgb("#F0EEF8"),
                        Margin = new Thickness(16, 0)
                    });
                var style = TopicStyles[i % TopicStyles.Length];
                TopicsContainer.Children.Add(BuildTopicRow(preview[i], style.emoji, style.bg));
            }

            if (topics.Count > 3)
            {
                TopicsContainer.Children.Add(new BoxView
                {
                    HeightRequest = 1,
                    Color = Color.FromArgb("#F0EEF8"),
                    Margin = new Thickness(16, 0)
                });
                MoreTopicsLabel.Text = $"View all {topics.Count} topics…";
                MoreTopicsRow.IsVisible = true;
            }
        }
        catch (Exception ex)
        {
            TopicsLoadingIndicator.IsVisible = false;
            TopicsEmptyState.IsVisible = true;
            System.Diagnostics.Debug.WriteLine($"[Myself] LoadTopics error: {ex.Message}");
        }
    }

    private View BuildTopicRow(TopicDto topic, string emoji, string bgColor)
    {
        var iconBorder = new Border
        {
            BackgroundColor = Color.FromArgb(bgColor),
            WidthRequest = 32,
            HeightRequest = 32,
            StrokeThickness = 0,
            StrokeShape = new RoundRectangle { CornerRadius = new CornerRadius(8) },
            Content = new Label
            {
                Text = emoji,
                FontSize = 15,
                HorizontalOptions = LayoutOptions.Center,
                VerticalOptions = LayoutOptions.Center
            }
        };

        var infoStack = new VerticalStackLayout
        {
            Margin = new Thickness(12, 0, 0, 0),
            VerticalOptions = LayoutOptions.Center,
            Spacing = 2
        };
        infoStack.Add(new Label
        {
            Text = topic.Title,
            FontSize = 14,
            FontAttributes = FontAttributes.Bold,
            TextColor = Color.FromArgb("#1A1A2E"),
            LineBreakMode = LineBreakMode.TailTruncation,
            MaxLines = 1
        });
        infoStack.Add(new Label
        {
            Text = BuildSubtitle(topic),
            FontSize = 12,
            TextColor = Color.FromArgb("#8888A0")
        });

        var grid = new Grid
        {
            ColumnDefinitions =
            {
                new ColumnDefinition(GridLength.Auto),
                new ColumnDefinition(GridLength.Star),
                new ColumnDefinition(GridLength.Auto)
            },
            Padding = new Thickness(16, 14)
        };
        Grid.SetColumn(iconBorder, 0);
        Grid.SetColumn(infoStack, 1);
        Grid.SetColumn(new Label { Text = "›", FontSize = 20, TextColor = Color.FromArgb("#B0A8C8"), VerticalOptions = LayoutOptions.Center }, 2);
        grid.Add(iconBorder);
        grid.Add(infoStack);
        grid.Add(new Label { Text = "›", FontSize = 20, TextColor = Color.FromArgb("#B0A8C8"), VerticalOptions = LayoutOptions.Center });

        grid.GestureRecognizers.Add(new TapGestureRecognizer
        {
            Command = new Command(async () => await NavigateToTopicAsync(topic))
        });

        return grid;
    }

    private static async Task NavigateToTopicAsync(TopicDto topic)
    {
        AI.PendingTopicId = topic.Id;
        AI.PendingTopicTitle = topic.Title;
        await Shell.Current.GoToAsync("//AI");
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
        return parts.Count > 0 ? string.Join(" · ", parts) : "Tap to view";
    }

    
    //  Other handlers (unchanged)
    

    private async void OnCompleteProfileTapped(object sender, TappedEventArgs e)
        => await Navigation.PushAsync(new CompleteProfilePage());

    private async void OnClearChatTapped(object sender, TappedEventArgs e)
    {
        bool confirm = await DisplayAlertAsync(
            "Clear Chat History",
            "Are you sure you want to clear all chat history? This action cannot be undone.",
            "Clear", "Cancel");
        if (!confirm) return;

        var userDbId = Preferences.Get("current_user_db_id", 0L);
        if (userDbId <= 0) { await DisplayAlertAsync("Done", "Chat history cleared.", "OK"); return; }

        try
        {
            await _chatApi.DeleteAllTopicsAsync(userDbId);
            await DisplayAlertAsync("Done", "Chat history has been cleared.", "OK");
            await LoadTopicsAsync();
        }
        catch (Exception ex)
        {
            await DisplayAlertAsync("Error", $"Failed to clear history: {ex.Message}", "OK");
        }
    }

    private async void OnMoreTopicsTapped(object sender, TappedEventArgs e)
        => await Navigation.PushAsync(new AllTopicsPage());

    private async void OnLogoutTapped(object sender, TappedEventArgs e)
    {
        bool confirm = await DisplayAlertAsync("Log Out", "Are you sure you want to log out?", "Log Out", "Cancel");
        if (!confirm) return;

        Preferences.Set("is_logged_in", false);
        foreach (var key in new[]
        {
            "current_username", "userId", "userEmail",
            "avatarUrl", "userBio", "userGender", "userRealName",
            "current_user_db_id", "avatarFileName"
        })
            Preferences.Remove(key);

        Application.Current!.Windows[0].Page = new NavigationPage(new LoginPage())
        {
            BarBackgroundColor = Color.FromArgb("#1A1A2E"),
            BarTextColor = Colors.White
        };
    }
}
