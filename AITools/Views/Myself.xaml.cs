namespace AITools.Views;


public partial class Myself : ContentPage
{
    public Myself()
    {
        InitializeComponent();
    }

    // ── Reload user info every time this tab becomes active ───
    protected override void OnAppearing()
    {
        base.OnAppearing();
        LoadUserInfo();
    }

    // ── Populate header card from persisted Preferences ──────
    private void LoadUserInfo()
    {
        // Username comes from Users.username (set at login / registration)
        var username = Preferences.Get("current_username", "Unknown User");

        // userId is the custom string ID generated at registration
        // e.g. "UID7482910356"
        var userId = Preferences.Get("userId", string.Empty);

        // Email from Users.email
        var email = Preferences.Get("userEmail", string.Empty);

        // real_name from UserProfiles — shown as subtitle if available
        var realName = Preferences.Get("userRealName", string.Empty);

        UsernameLabel.Text = string.IsNullOrEmpty(realName) ? username : realName;
        UserIdLabel.Text = string.IsNullOrEmpty(userId)
            ? "User ID: —"
            : $"User ID: {userId}";
    }

    // ── Navigate to Complete Profile page ──
    private async void OnCompleteProfileTapped(object sender, TappedEventArgs e)
        => await Navigation.PushAsync(new CompleteProfilePage());

    // ── Clear chat history ──
    private async void OnClearChatTapped(object sender, TappedEventArgs e)
    {
        bool confirm = await DisplayAlertAsync(
            "Clear Chat History",
            "Are you sure you want to clear all chat history? This action cannot be undone.",
            "Clear",
            "Cancel");

        if (confirm)
        {
            // TODO: call ChatMessage delete API
            await DisplayAlertAsync("Done", "Chat history has been cleared.", "OK");
        }
    }

    // ── Topic tapped ──
    private async void OnTopicTapped(object sender, TappedEventArgs e)
    {
        string topicId = e.Parameter as string ?? string.Empty;
        await DisplayAlertAsync("Topic", $"Topic {topicId} — detail page coming soon ✨", "OK");
    }

    // ── More topics ──
    private async void OnMoreTopicsTapped(object sender, TappedEventArgs e)
        => await DisplayAlertAsync("More Topics", "Full topic list — coming soon ✨", "OK");

    // ── Log out ──────────────────────────────────────────────
    private async void OnLogoutTapped(object sender, TappedEventArgs e)
    {
        bool confirm = await DisplayAlertAsync(
            "Log Out",
            "Are you sure you want to log out?",
            "Log Out",
            "Cancel");

        if (!confirm) return;

        // Clear all session data
        Preferences.Set("is_logged_in", false);
        foreach (var key in new[]
        {
            "current_username", "userId", "userEmail",
            "avatarUrl", "userBio", "userGender", "userRealName"
        })
            Preferences.Remove(key);

        // Return to login page
        Application.Current!.Windows[0].Page = new NavigationPage(new LoginPage())
        {
            BarBackgroundColor = Color.FromArgb("#1A1A2E"),
            BarTextColor = Colors.White
        };
    }
}