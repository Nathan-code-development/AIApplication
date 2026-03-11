using Microsoft.Maui.Controls;

namespace AITools.Views;

public partial class RegisterPage : ContentPage
{
    // Simulated verification code (in production, generated and sent by backend)
    private string _generatedCode = string.Empty;
    private bool _codeSent = false;
    private int _countdown = 0;
    private IDispatcherTimer? _timer;   // Use MAUI IDispatcherTimer — compatible with Android/iOS/Windows

    public RegisterPage()
    {
        InitializeComponent();
    }

    // ── Send verification code ──
    private async void OnSendCodeTapped(object sender, TappedEventArgs e)
    {
        if (_countdown > 0) return; // Prevent re-sending during countdown

        string email = EmailEntry.Text?.Trim() ?? string.Empty;
        if (string.IsNullOrEmpty(email) || !email.Contains('@'))
        {
            ShowError("Please enter a valid email address first.");
            return;
        }

        // Generate a 6-digit simulated verification code
        _generatedCode = new Random().Next(100000, 999999).ToString();
        _codeSent = true;

        // In production, replace this with a real email-sending API call
        await DisplayAlertAsync("Verification Code (Demo)",
            $"Your code is: {_generatedCode}\n(In production this would be sent to {email})",
            "OK");

        // Start a 60-second countdown
        _countdown = 60;
        StartCountdown();
    }

    // ── Countdown timer using MAUI IDispatcherTimer (UI-thread safe) ──
    private void StartCountdown()
    {
        _timer = Application.Current!.Dispatcher.CreateTimer();
        _timer.Interval = TimeSpan.FromSeconds(1);
        _timer.Tick += (s, e) =>
        {
            _countdown--;
            if (_countdown > 0)
            {
                SendCodeLabel.Text = $"{_countdown}s";
            }
            else
            {
                SendCodeLabel.Text = "Send code";
                _timer?.Stop();
                _timer = null;
            }
        };
        _timer.Start();
    }

    // ── Register ──
    private async void OnRegisterClicked(object sender, EventArgs e)
    {
        string username = UsernameEntry.Text?.Trim() ?? string.Empty;
        string email = EmailEntry.Text?.Trim() ?? string.Empty;
        string password = PasswordEntry.Text?.Trim() ?? string.Empty;
        string confirm = ConfirmPasswordEntry.Text?.Trim() ?? string.Empty;
        string code = CodeEntry.Text?.Trim() ?? string.Empty;

        // ── Validation ──
        if (string.IsNullOrEmpty(username))
        { ShowError("Username cannot be empty."); return; }

        if (string.IsNullOrEmpty(email) || !email.Contains('@'))
        { ShowError("Please enter a valid email address."); return; }

        if (password.Length < 6)
        { ShowError("Password must be at least 6 characters."); return; }

        if (password != confirm)
        { ShowError("Passwords do not match."); return; }

        if (!_codeSent)
        { ShowError("Please send the verification code first."); return; }

        if (code != _generatedCode)
        { ShowError("Incorrect verification code."); return; }

        // ── Save account locally (replace with backend registration API in production) ──
        Preferences.Set("registered_username", username);
        Preferences.Set("registered_password", password);
        Preferences.Set("registered_email", email);

        _timer?.Stop();

        await DisplayAlertAsync("Success", "Account registered successfully! Please login.", "OK");

        // Navigate back to login page
        await Navigation.PopAsync();
    }

    // ── Navigate to login page ──
    private async void OnGoToLoginTapped(object sender, TappedEventArgs e)
    {
        await Navigation.PopAsync();
    }

    private void ShowError(string message)
    {
        ErrorLabel.Text = message;
        ErrorLabel.TextColor = message.Contains("Success")
            ? Color.FromArgb("#4CAF50")
            : Color.FromArgb("#E94560");
        ErrorLabel.IsVisible = true;
    }

    protected override void OnDisappearing()
    {
        base.OnDisappearing();
        _timer?.Stop();
    }
}
