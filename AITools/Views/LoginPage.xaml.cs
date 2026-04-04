using AITools.Services;

namespace AITools.Views;

public partial class LoginPage : ContentPage
{
    private readonly AuthService _auth = new();
    private bool _isLoading = false;

    public LoginPage()
    {
        InitializeComponent();
    }

    // ── Login ──────────────────────────────────────────────────
    private async void OnLoginClicked(object sender, EventArgs e)
    {
        if (_isLoading) return;

        var username = UsernameEntry.Text?.Trim() ?? string.Empty;
        var password = PasswordEntry.Text?.Trim() ?? string.Empty;

        if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
        {
            ShowError("Please enter your username and password.");
            return;
        }

        SetLoading(true);
        HideError();

        var (user, error) = await _auth.LoginAsync(username, password);

        SetLoading(false);

        if (error != null)
        {
            ShowError(error);
            return;
        }

        // ── Persist session ──
        Preferences.Set("is_logged_in", true);
        Preferences.Set("current_username", user!.Username ?? username);
        Preferences.Set("userId", user.UserId);           // "UID..." display string
        Preferences.Set("current_user_db_id", user.DbId);             // Auto-increment Long — FK for user_profiles
        Preferences.Set("userEmail", user.Email ?? string.Empty);
        Preferences.Set("avatarUrl", user.AvatarUrl ?? string.Empty);
        Preferences.Set("userBio", string.Empty);
        Preferences.Set("userGender", string.Empty);
        Preferences.Set("userRealName", string.Empty);
        Preferences.Set("userPhone", string.Empty);

        // ── Navigate to main shell, open "Myself" tab ──
        var appShell = new AppShell();
        appShell.CurrentItem = appShell.Items[0].Items[2];
        Application.Current!.Windows[0].Page = appShell;
    }

    private async void OnGoToRegisterTapped(object sender, TappedEventArgs e)
        => await Navigation.PushAsync(new RegisterPage());

    private void SetLoading(bool loading)
    {
        _isLoading = loading;
        LoginButtonLabel.Text = loading ? "Logging in…" : "Login";
        LoginLoadingIndicator.IsVisible = loading;
        LoginLoadingIndicator.IsRunning = loading;
    }

    private void ShowError(string msg)
    {
        ErrorLabel.Text = msg;
        ErrorLabel.IsVisible = true;
    }

    private void HideError() => ErrorLabel.IsVisible = false;
}