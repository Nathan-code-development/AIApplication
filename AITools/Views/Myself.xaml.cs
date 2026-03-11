namespace AITools.Views;

public partial class Myself : ContentPage
{
    public Myself()
    {
        InitializeComponent();
    }

    // ── Complete profile ──
    private async void OnCompleteProfileTapped(object sender, TappedEventArgs e)
    {
        // TODO: Navigate to complete profile page
        await DisplayAlertAsync("Notice", "Complete profile feature coming soon ✨", "OK");
    }

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
            // TODO: Execute clear logic
            await DisplayAlertAsync("Notice", "Chat history cleared.", "OK");
        }
    }

    // ── Topic tapped ──
    private async void OnTopicTapped(object sender, TappedEventArgs e)
    {
        string topicId = e.Parameter as string ?? string.Empty;
        // TODO: Navigate to topic detail page
        await DisplayAlertAsync("Topic", $"Topic {topicId} detail page coming soon ✨", "OK");
    }

    // ── More topics ──
    private async void OnMoreTopicsTapped(object sender, TappedEventArgs e)
    {
        // TODO: Navigate to full topic list
        await DisplayAlertAsync("More Topics", "Full topic list coming soon ✨", "OK");
    }

    // ── Logout ──
    private async void OnLogoutTapped(object sender, TappedEventArgs e)
    {
        bool confirm = await DisplayAlertAsync(
            "Log Out",
            "Are you sure you want to log out?",
            "Log Out",
            "Cancel");

        if (confirm)
        {
            // Clear login state
            Preferences.Set("is_logged_in", false);
            Preferences.Remove("current_username");

            // Navigate back to login page
            // Use Windows[0].Page instead of MainPage (MainPage is deprecated in .NET 10 MAUI)
            Application.Current!.Windows[0].Page = new NavigationPage(new LoginPage())
            {
                // Match the status bar to the app theme color
                BarBackgroundColor = Color.FromArgb("#1A1A2E"),
                BarTextColor = Colors.White
            };
        }
    }
}
