using Android.App;
using Android.Content.PM;
using Android.OS;
using Android.Views;
using AndroidX.Core.View;
using Microsoft.Maui;

namespace AITools
{
    [Activity(
        Theme = "@style/Maui.SplashTheme",
        MainLauncher = true,
        LaunchMode = LaunchMode.SingleTop,
        ConfigurationChanges =
            ConfigChanges.ScreenSize |
            ConfigChanges.Orientation |
            ConfigChanges.UiMode |
            ConfigChanges.ScreenLayout |
            ConfigChanges.SmallestScreenSize |
            ConfigChanges.Density)]
    public class MainActivity : MauiAppCompatActivity
    {
        protected override void OnCreate(Bundle? savedInstanceState)
        {
            base.OnCreate(savedInstanceState);

            if (Window != null)
            {
                // Android 35+ compatible: use WindowCompat instead of deprecated APIs
                WindowCompat.SetDecorFitsSystemWindows(Window, false);

                // Set status bar color via WindowInsetsControllerCompat (no deprecation warning)
                var insetsController = WindowCompat.GetInsetsController(Window, Window.DecorView);
                // false = white icons on status bar (suitable for dark background)
                insetsController?.AppearanceLightStatusBars = false;
            }
        }
    }
}
