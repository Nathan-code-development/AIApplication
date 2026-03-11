namespace AITools.Views;

public partial class LoginPage : ContentPage
{
    public LoginPage()
    {
        InitializeComponent();
    }

    private async void OnLoginClicked(object sender, EventArgs e)
    {
        string username = UsernameEntry.Text?.Trim() ?? string.Empty;
        string password = PasswordEntry.Text?.Trim() ?? string.Empty;

        // ── Basic validation ──
        if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
        {
            ShowError("Please enter username and password.");
            return;
        }

        // ── Simple local logic: read the saved account from registration ──
        string? savedUser = Preferences.Get("registered_username", null);
        string? savedPass = Preferences.Get("registered_password", null);

        if (savedUser == null)
        {
            ShowError("No account found. Please register first.");
            return;
        }

        if (username != savedUser || password != savedPass)
        {
            ShowError("Incorrect username or password.");
            return;
        }

        // ── Login success: save login state and navigate to main page ──
        Preferences.Set("is_logged_in", true);
        Preferences.Set("current_username", username);

        // Switch to Shell main navigation (includes bottom tab bar)
        var appShell = new AppShell();
        appShell.CurrentItem = appShell.Items[0].Items[2];   // Use MySelf Page
        Application.Current!.Windows[0].Page = appShell; // Redirect to MySelf page after login
    }

    private async void OnGoToRegisterTapped(object sender, TappedEventArgs e)
    {
        await Navigation.PushAsync(new RegisterPage());
    }

    private void ShowError(string message)
    {
        ErrorLabel.Text = message;
        ErrorLabel.IsVisible = true;
    }
}
