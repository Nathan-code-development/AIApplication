using Microsoft.Maui.Controls;
using System.Collections.Generic;

namespace AITools.Models
{
    // Main model class used for both list and detail pages
    public class AIModel
    {
        // List page basic fields
        public required string Name { get; set; }
        public required ImageSource IconSource { get; set; }

        // Detail page fields
        public string Company { get; set; } = string.Empty;
        public string Slogan { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;

        // Primary theme color used for hero gradient start
        public Color ThemeColor { get; set; } = Color.FromArgb("#4A90D9");

        // Hero gradient end color
        public Color ThemeColorDark { get; set; } = Color.FromArgb("#2C5FAA");

        public double Rating { get; set; } = 4.5;
        public string ReviewCount { get; set; } = "0";

        // Capability tags shown in hero, e.g. "Writing", "Reasoning"
        public List<string> Tags { get; set; } = new();

        // Radar chart scores (0-100)
        public int RadarReasoning { get; set; }
        public int RadarWriting { get; set; }
        public int RadarCode { get; set; }
        public int RadarAnalysis { get; set; }
        public int RadarMultilingual { get; set; }
        public int RadarSpeed { get; set; }

        // Use cases shown in overview tab
        public List<UseCase> UseCases { get; set; } = new();

        // Technical specs
        public string ContextWindow { get; set; } = string.Empty;
        public string SupportedLanguages { get; set; } = string.Empty;
        public string ResponseSpeed { get; set; } = string.Empty;
        public bool SupportsWebSearch { get; set; }
        public bool SupportsToolCall { get; set; }
        public List<string> InputTypes { get; set; } = new();

        // Pricing plans
        public List<PricingPlan> PricingPlans { get; set; } = new();

        // Comparison data
        public List<CompareItem> CompareItems { get; set; } = new();
        public string CompareNote { get; set; } = string.Empty;

        // User reviews
        public List<int> RatingDistribution { get; set; } = new() { 0, 0, 0, 0, 0 };
        public List<UserReview> UserReviews { get; set; } = new();
    }

    // Use case card shown in overview tab
    public class UseCase
    {
        public string Icon { get; set; } = string.Empty;
        public string Title { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
    }

    // Pricing plan row shown in specs tab
    public class PricingPlan
    {
        public string PlanName { get; set; } = string.Empty;
        public string Price { get; set; } = string.Empty;
        public bool IsHighlighted { get; set; }
    }

    // Single model entry in the compare tab bar chart
    public class CompareItem
    {
        public string ModelName { get; set; } = string.Empty;
        public int Code { get; set; }
        public int Writing { get; set; }
        public int Reasoning { get; set; }
        public int Speed { get; set; }

        // Bar color used to distinguish models in the chart
        public Color BarColor { get; set; } = Color.FromArgb("#4A90D9");
    }

    // User review card shown in reviews tab
    public class UserReview
    {
        public string UserName { get; set; } = string.Empty;
        public int Score { get; set; }
        public string Content { get; set; } = string.Empty;

        // Computed star string, e.g. "★★★★☆"
        public string Stars => new string('★', Score) + new string('☆', 5 - Score);
    }
}