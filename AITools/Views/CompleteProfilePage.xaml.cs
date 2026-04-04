using AITools.Services;

namespace AITools.Views;

public partial class CompleteProfilePage : ContentPage
{
    private readonly UserProfileService _profileSvc = new();
    private bool _isSaving = false;

    public CompleteProfilePage()
    {
        InitializeComponent();

        // Live character counter for the Bio field
        BioEditor.TextChanged += (_, _) =>
            BioCharCount.Text = $"{BioEditor.Text?.Length ?? 0} / 200";
    }

    // ── Pre-fill fields with previously saved values ──────────
    protected override void OnAppearing()
    {
        base.OnAppearing();

        DisplayNameEntry.Text = Preferences.Get("userRealName", string.Empty);
        BioEditor.Text = Preferences.Get("userBio", string.Empty);

        // Restore gender selection
        var savedGender = Preferences.Get("userGender", string.Empty);
        if (!string.IsNullOrEmpty(savedGender))
        {
            var idx = GenderPicker.Items.IndexOf(savedGender);
            if (idx >= 0) GenderPicker.SelectedIndex = idx;
        }

        // Restore phone — split into country code + number
        var savedPhone = Preferences.Get("userPhone", string.Empty);
        if (!string.IsNullOrEmpty(savedPhone))
        {
            if (savedPhone.StartsWith("+86"))
            {
                CountryCodePicker.SelectedItem = "+86";
                PhoneEntry.Text = savedPhone.Substring(3);
            }
            else if (savedPhone.StartsWith("+65"))
            {
                CountryCodePicker.SelectedItem = "+65";
                PhoneEntry.Text = savedPhone.Substring(3);
            }
            else
            {
                CountryCodePicker.SelectedItem = "+86";
                PhoneEntry.Text = savedPhone;
            }
        }
        else
        {
            // Default country code
            if (CountryCodePicker.Items.Contains("+86"))
                CountryCodePicker.SelectedItem = "+86";
        }
    }

    // ── Back without saving ──
    private async void OnBackTapped(object sender, TappedEventArgs e)
        => await Navigation.PopAsync();

    // ── Save Profile ──────────────────────────────────────────
    //  Fields → backend UserProfiles entity:
    //    DisplayName → realName
    //    Gender label → gender (int 0–3)
    //    Bio → introduction
    //    CountryCode + PhoneNumber → phone
    // ─────────────────────────────────────────────────────────
    private async void OnSaveProfileTapped(object sender, TappedEventArgs e)
    {
        if (_isSaving) return;

        var displayName = DisplayNameEntry.Text?.Trim() ?? string.Empty;
        var genderLabel = GenderPicker.SelectedItem?.ToString() ?? string.Empty;
        var bio = BioEditor.Text?.Trim() ?? string.Empty;
        var countryCode = CountryCodePicker.SelectedItem?.ToString() ?? "+86";
        var phoneNumber = PhoneEntry.Text?.Trim() ?? string.Empty;

        // Combine country code + number into a single string
        var fullPhone = string.IsNullOrEmpty(phoneNumber)
            ? string.Empty
            : $"{countryCode}{phoneNumber.Replace(" ", "")}";

        // Validate required field
        if (string.IsNullOrEmpty(displayName))
        {
            ShowFeedback("Display name cannot be empty.", isError: true);
            return;
        }

        // ── Get the auto-increment DB id stored at login ──────
        // This is users.id (Long), which is the FK in user_profiles.user_id.
        // It is saved into Preferences as "current_user_db_id" during LoginPage login.
        var userDbId = Preferences.Get("current_user_db_id", 0L);
        if (userDbId == 0)
        {
            ShowFeedback("Session error: please log out and log in again.", isError: true);
            return;
        }

        SetSaving(true);
        HideFeedback();

        var (success, error) = await _profileSvc.UpdateProfileAsync(
            userDbId, displayName, genderLabel, bio, fullPhone);

        SetSaving(false);

        if (!success)
        {
            ShowFeedback(error ?? "Failed to save profile. Please try again.", isError: true);
            return;
        }

        // ── Update local Preferences so Myself page shows latest values ──
        Preferences.Set("userRealName", displayName);
        Preferences.Set("userGender", genderLabel);
        Preferences.Set("userBio", bio);
        Preferences.Set("userPhone", fullPhone);

        ShowFeedback("Profile saved successfully!", isError: false);
        await Task.Delay(900);
        await Navigation.PopAsync();
    }

    // ── UI helpers ────────────────────────────────────────────
    private void SetSaving(bool saving)
    {
        _isSaving = saving;
        SaveButtonLabel.IsVisible = !saving;
        SaveIndicator.IsVisible = saving;
        SaveIndicator.IsRunning = saving;
    }

    private void ShowFeedback(string msg, bool isError)
    {
        FeedbackLabel.Text = msg;
        FeedbackLabel.TextColor = isError
            ? Color.FromArgb("#E94560")
            : Color.FromArgb("#22C55E");
        FeedbackLabel.IsVisible = true;
    }

    private void HideFeedback() => FeedbackLabel.IsVisible = false;
}