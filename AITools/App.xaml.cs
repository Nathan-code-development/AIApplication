namespace AITools;

public partial class App : Application
{
    public App()
    {
        InitializeComponent();
    }

    protected override Window CreateWindow(IActivationState? activationState)
    {
        // Check if the user is already logged in
        bool isLoggedIn = Preferences.Get("is_logged_in", false);

        Page startPage;

        if (isLoggedIn)
        {
            // Logged in → go directly to the main UI (Shell with bottom tabs)
            startPage = new AppShell();
        }
        else
        {
            // Not logged in → show login page (wrapped in NavigationPage to support push to register)
            startPage = new NavigationPage(new Views.LoginPage())
            {
                // Match the status bar to the app theme color
                BarBackgroundColor = Color.FromArgb("#1A1A2E"),
                BarTextColor = Colors.White
            };
        }

        return new Window(startPage);
    }
}
