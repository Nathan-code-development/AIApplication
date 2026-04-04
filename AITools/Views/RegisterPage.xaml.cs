using AITools.Services;

namespace AITools.Views;

public partial class RegisterPage : ContentPage
{
    // ── Services ──────────────────────────────────────────────
    private readonly AuthService _auth = new();
    private readonly EmailCodeService _emailSvc = new();

    // ── State flags ───────────────────────────────────────────
    private bool _isRegistering = false;   // Prevent double-tap on Register button
    private bool _isSendingCode = false;   // Prevent double-tap on Send Code button
    private bool _codeSent = false;   // True once server confirms code was sent

    // Countdown cancellation — cancelled if user somehow taps Send again
    private CancellationTokenSource? _countdownCts;

    public RegisterPage()
    {
        InitializeComponent();
    }

    // ─────────────────────────────────────────────────────────
    //  Send Verification Code
    //  Calls: POST /api/v1/email/send-code  { email }
    //  On success: starts a 60-second countdown on SendCodeLabel
    // ─────────────────────────────────────────────────────────
    private async void OnSendCodeTapped(object sender, TappedEventArgs e)
    {
        if (_isSendingCode) return;

        var email = EmailEntry.Text?.Trim() ?? string.Empty;

        // Validate email format before hitting the network
        if (string.IsNullOrEmpty(email) || !email.Contains('@') || !email.Contains('.'))
        {
            ShowError("Please enter a valid email address first.");
            return;
        }

        _isSendingCode = true;
        SendCodeLabel.Text = "Sending…";
        HideError();

        var (success, error) = await _emailSvc.SendCodeAsync(email);

        _isSendingCode = false;

        if (!success)
        {
            SendCodeLabel.Text = "Send code";   // Reset button text on failure
            ShowError(TranslateMsg(error));
            return;
        }

        // ── Code dispatched — start countdown ──
        _codeSent = true;
        ShowSuccess("Code sent! Please check your inbox.");
        StartCountdown(60);
    }

    // ─────────────────────────────────────────────────────────
    //  Register
    //  Flow:
    //    1. Local field validation (no network)
    //    2. POST /api/v1/email/verify-code  { email, code }
    //    3. Generate userId client-side  ("UID" + 10 random digits)
    //    4. POST /Users/insertUser
    //         { userId, username, email, passwordHash,
    //           avatarUrl, lastLoginAt, createdAt }
    // ─────────────────────────────────────────────────────────
    private async void OnRegisterClicked(object sender, EventArgs e)
    {
        if (_isRegistering) return;

        // Read all fields
        var username = UsernameEntry.Text?.Trim() ?? string.Empty;
        var email = EmailEntry.Text?.Trim() ?? string.Empty;
        var password = PasswordEntry.Text?.Trim() ?? string.Empty;
        var confirm = ConfirmPasswordEntry.Text?.Trim() ?? string.Empty;
        var code = CodeEntry.Text?.Trim() ?? string.Empty;

        // ── Local validation ──────────────────────────────────
        if (string.IsNullOrEmpty(username))
        { ShowError("Username cannot be empty."); return; }

        if (username.Length < 3 || username.Length > 20)
        { ShowError("Username must be 3–20 characters."); return; }

        if (string.IsNullOrEmpty(email) || !email.Contains('@') || !email.Contains('.'))
        { ShowError("Please enter a valid email address."); return; }

        if (password.Length < 6)
        { ShowError("Password must be at least 6 characters."); return; }

        if (password != confirm)
        { ShowError("Passwords do not match."); return; }

        if (!_codeSent)
        { ShowError("Please send the verification code to your email first."); return; }

        if (code.Length != 6)
        { ShowError("Please enter the 6-digit verification code."); return; }

        SetRegistering(true);
        HideError();

        // ── Step 1: Verify code against backend Redis store ───
        var (codeOk, codeErr) = await _emailSvc.VerifyCodeAsync(email, code);
        if (!codeOk)
        {
            SetRegistering(false);
            ShowError(TranslateMsg(codeErr) ?? "Incorrect or expired code. Try again.");
            return;
        }

        // ── Step 2: Generate a unique userId on the client ────
        // Stored in Users.userId (VARCHAR) in the database.
        // Format example: "UID4829301756"
        var userId = "UID" + new Random().NextInt64(1_000_000_000L, 9_999_999_999L);

        // ── Step 3: Create account via POST /Users/insertUser ─
        var (regOk, regErr) = await _auth.RegisterAsync(username, email, password, userId);

        SetRegistering(false);

        if (!regOk)
        {
            ShowError(regErr ?? "Registration failed. Please try again.");
            return;
        }

        // ── Success: inform user and go back to login ─────────
        ShowSuccess("Account created successfully! Redirecting to login…");
        await Task.Delay(1200);
        await Navigation.PopAsync();
    }

    // ── Navigate back to login ──
    private async void OnGoToLoginTapped(object sender, TappedEventArgs e)
        => await Navigation.PopAsync();

    // ─────────────────────────────────────────────────────────
    //  60-second countdown on SendCodeLabel
    //  The XAML has no x:Name on the Border, only on the Label,
    //  so we control appearance purely through SendCodeLabel.Text.
    // ─────────────────────────────────────────────────────────
    private void StartCountdown(int totalSeconds)
    {
        _countdownCts?.Cancel();
        _countdownCts = new CancellationTokenSource();
        var token = _countdownCts.Token;

        Task.Run(async () =>
        {
            for (int i = totalSeconds; i > 0; i--)
            {
                if (token.IsCancellationRequested) return;

                int remaining = i;
                MainThread.BeginInvokeOnMainThread(()
                    => SendCodeLabel.Text = $"Resend ({remaining}s)");

                await Task.Delay(1000, token);
            }

            // Countdown finished — restore button label
            if (!token.IsCancellationRequested)
                MainThread.BeginInvokeOnMainThread(()
                    => SendCodeLabel.Text = "Send code");

        }, token);
    }

    // ─────────────────────────────────────────────────────────
    //  Translate backend Chinese error messages → English
    // ─────────────────────────────────────────────────────────
    private static string TranslateMsg(string? msg) => msg switch
    {
        "请求过于频繁，请60秒后再试" => "Too many requests — please wait 60 seconds.",
        "验证码已过期，请重新获取" => "Code expired. Please request a new one.",
        "验证码错误" => "Incorrect verification code.",
        "邮件发送失败，请稍后重试" => "Email delivery failed. Please try again later.",
        _ => msg ?? "An unknown error occurred."
    };

    // ─────────────────────────────────────────────────────────
    //  UI helpers
    // ─────────────────────────────────────────────────────────

    // Switch Register button between normal ↔ loading state
    private void SetRegistering(bool loading)
    {
        _isRegistering = loading;
        RegisterButtonLabel.IsVisible = !loading;
        RegisterLoadingIndicator.IsVisible = loading;
        RegisterLoadingIndicator.IsRunning = loading;
    }

    // Red error text (reuses ErrorLabel)
    private void ShowError(string msg)
    {
        ErrorLabel.Text = msg;
        ErrorLabel.TextColor = Color.FromArgb("#E94560");
        ErrorLabel.IsVisible = true;
    }

    // Green success text (reuses ErrorLabel)
    private void ShowSuccess(string msg)
    {
        ErrorLabel.Text = msg;
        ErrorLabel.TextColor = Color.FromArgb("#22C55E");
        ErrorLabel.IsVisible = true;
    }

    private void HideError() => ErrorLabel.IsVisible = false;
}