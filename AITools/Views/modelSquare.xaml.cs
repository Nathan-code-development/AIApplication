using AITools.Models;
using Microsoft.Maui.Controls;
using System.Collections.Generic;

namespace AITools.Views
{
    public partial class modelSquare : ContentPage
    {
        // Full detail data keyed by model name
        private readonly Dictionary<string, AIModel> _modelDetails = BuildModelDetails();

        public modelSquare()
        {
            InitializeComponent();

            // List items only need Name + Icon — same as original
            var models = new List<AIModel>
            {
                new AIModel { Name = "DeepSeek", IconSource = ImageSource.FromFile("deep_seek.png") },
                new AIModel { Name = "Qwen",     IconSource = ImageSource.FromFile("model_square.png") },
                new AIModel { Name = "ChatGPT",  IconSource = ImageSource.FromFile("chat_gpt.png") },
                new AIModel { Name = "DouBao",   IconSource = ImageSource.FromFile("doubao.png") },
                new AIModel { Name = "Gemini",   IconSource = ImageSource.FromFile("gemini.png") },
                new AIModel { Name = "Claude",   IconSource = ImageSource.FromFile("claude.png") },
                new AIModel { Name = "Grok",     IconSource = ImageSource.FromFile("grok.png") },
                new AIModel { Name = "Kimi",     IconSource = ImageSource.FromFile("kimi.png") },
            };

            ModelsCollectionView.ItemsSource = models;
        }

        // Tap a model card -> navigate to detail page
        private async void OnModelSelected(object sender, SelectionChangedEventArgs e)
        {
            if (e.CurrentSelection.Count == 0) return;

            var selected = e.CurrentSelection[0] as AIModel;
            // Clear immediately so tapping the same card again works
            ModelsCollectionView.SelectedItem = null;

            if (selected is null) return;

            // Use full detail data if available, otherwise fall back to list item
            AIModel detailModel = _modelDetails.TryGetValue(selected.Name, out AIModel? detail)
                ? detail
                : selected;

            // Reuse the icon already loaded for the list
            detailModel.IconSource = selected.IconSource;

            // Wrap in NavigationPage to ensure PushAsync works under Shell tabs
            var detailPage = new ModelDetailPage(detailModel);
            var navPage = new NavigationPage(detailPage)
            {
                BarBackgroundColor = Color.FromArgb("#0F0F13"),
                BarTextColor = Colors.White
            };
            await Application.Current!.Windows[0].Page!.Navigation.PushModalAsync(navPage);
        }

        //  Full detail data for all 8 models 
        private static Dictionary<string, AIModel> BuildModelDetails()
        {
            return new Dictionary<string, AIModel>
            {
                //  Claude 
                ["Claude"] = new AIModel
                {
                    Name = "Claude",
                    IconSource = ImageSource.FromFile("claude.png"),
                    Company = "Anthropic",
                    Slogan = "AI that's safe, helpful, and honest",
                    Description = "Claude is a next-generation AI assistant built by Anthropic with safety, honesty, and helpfulness at its core. It excels at deep analysis, creative writing, and complex reasoning, with a 200K-token context window capable of processing entire books or large codebases.",
                    ThemeColor = Color.FromArgb("#C96442"),
                    ThemeColorDark = Color.FromArgb("#8B3A2A"),
                    Rating = 4.8,
                    ReviewCount = "12.4k",
                    Tags = new() { "Writing", "Reasoning", "Code", "Analysis", "Long context" },

                    RadarReasoning = 92,
                    RadarWriting = 95,
                    RadarCode = 85,
                    RadarAnalysis = 95,
                    RadarMultilingual = 90,
                    RadarSpeed = 80,

                    UseCases = new()
                    {
                        new UseCase { Icon = "✍️", Title = "Long-form Writing",  Description = "Reports, novels, essay editing" },
                        new UseCase { Icon = "🔍", Title = "Deep Analysis",      Description = "Research reports, data insights" },
                        new UseCase { Icon = "💻", Title = "Code Development",   Description = "Write, debug and refactor code" },
                        new UseCase { Icon = "📚", Title = "Document Processing",Description = "Summarize large documents" },
                    },

                    ContextWindow = "200K tokens",
                    SupportedLanguages = "100+",
                    ResponseSpeed = "Fast",
                    SupportsWebSearch = true,
                    SupportsToolCall = true,
                    InputTypes = new() { "Text", "Image", "File" },

                    PricingPlans = new()
                    {
                        new PricingPlan { PlanName = "Free",   Price = "Limited daily usage", IsHighlighted = false },
                        new PricingPlan { PlanName = "Pro",    Price = "$20 / month",          IsHighlighted = true  },
                        new PricingPlan { PlanName = "API",    Price = "Pay as you go",        IsHighlighted = false },
                    },

                    CompareItems = new()
                    {
                        new CompareItem { ModelName = "Claude",  Code = 85, Writing = 95, Reasoning = 92, Speed = 80, BarColor = Color.FromArgb("#C96442") },
                        new CompareItem { ModelName = "GPT-4o",  Code = 88, Writing = 87, Reasoning = 88, Speed = 85, BarColor = Color.FromArgb("#4A90D9") },
                        new CompareItem { ModelName = "Gemini",  Code = 82, Writing = 83, Reasoning = 85, Speed = 90, BarColor = Color.FromArgb("#34C78A") },
                    },
                    CompareNote = "Claude leads in writing and analysis. Its 200K context window is a standout advantage. Code performance is on par with GPT-4o. Best suited for tasks that demand high output quality.",

                    RatingDistribution = new() { 72, 18, 7, 2, 1 },
                    UserReviews = new()
                    {
                        new UserReview { UserName = "Zhang**", Score = 5, Content = "Exceptional reasoning. Handles complex problems with a clarity that exceeds expectations." },
                        new UserReview { UserName = "Li**",    Score = 5, Content = "Natural writing style. Generated content rarely needs editing." },
                        new UserReview { UserName = "Wang**",  Score = 4, Content = "Excellent Chinese comprehension. Occasionally a bit overly cautious in replies." },
                    }
                },

                //  ChatGPT 
                ["ChatGPT"] = new AIModel
                {
                    Name = "ChatGPT",
                    IconSource = ImageSource.FromFile("chat_gpt.png"),
                    Company = "OpenAI",
                    Slogan = "Versatile AI for every task",
                    Description = "ChatGPT is OpenAI's flagship conversational model with the largest global user base. It supports image understanding, web search, and a rich plugin ecosystem, making it suitable for everyday tasks and professional use alike.",
                    ThemeColor = Color.FromArgb("#10A37F"),
                    ThemeColorDark = Color.FromArgb("#0A7A60"),
                    Rating = 4.7,
                    ReviewCount = "98.2k",
                    Tags = new() { "General", "Plugins", "Code", "Vision", "Multimodal" },

                    RadarReasoning = 88,
                    RadarWriting = 85,
                    RadarCode = 88,
                    RadarAnalysis = 82,
                    RadarMultilingual = 85,
                    RadarSpeed = 85,

                    UseCases = new()
                    {
                        new UseCase { Icon = "💬", Title = "Daily Chat",     Description = "Q&A and brainstorming" },
                        new UseCase { Icon = "🖼️", Title = "Vision",         Description = "Image analysis and description" },
                        new UseCase { Icon = "🔌", Title = "Plugin Ecosystem",Description = "Access rich third-party tools" },
                        new UseCase { Icon = "📊", Title = "Data Analysis",   Description = "Python code execution" },
                    },

                    ContextWindow = "128K tokens",
                    SupportedLanguages = "95+",
                    ResponseSpeed = "Fast",
                    SupportsWebSearch = true,
                    SupportsToolCall = true,
                    InputTypes = new() { "Text", "Image", "File" },

                    PricingPlans = new()
                    {
                        new PricingPlan { PlanName = "Free",  Price = "GPT-3.5",      IsHighlighted = false },
                        new PricingPlan { PlanName = "Plus",  Price = "$20 / month",  IsHighlighted = true  },
                        new PricingPlan { PlanName = "API",   Price = "Pay as you go", IsHighlighted = false },
                    },

                    CompareItems = new()
                    {
                        new CompareItem { ModelName = "ChatGPT", Code = 88, Writing = 85, Reasoning = 88, Speed = 85, BarColor = Color.FromArgb("#10A37F") },
                        new CompareItem { ModelName = "Claude",  Code = 85, Writing = 95, Reasoning = 92, Speed = 80, BarColor = Color.FromArgb("#C96442") },
                        new CompareItem { ModelName = "Gemini",  Code = 82, Writing = 83, Reasoning = 85, Speed = 90, BarColor = Color.FromArgb("#4A90D9") },
                    },
                    CompareNote = "ChatGPT has the most mature ecosystem. Its plugin and tool-calling capabilities lead the field. Balanced code and reasoning performance makes it the most widely-used AI assistant.",

                    RatingDistribution = new() { 65, 22, 9, 3, 1 },
                    UserReviews = new()
                    {
                        new UserReview { UserName = "Chen**", Score = 5, Content = "The plugin system is incredibly powerful. Direct web page control has massively boosted my productivity." },
                        new UserReview { UserName = "Zhao**", Score = 4, Content = "Great for daily use, but occasional hallucinations mean you still need to verify outputs." },
                        new UserReview { UserName = "Liu**",  Score = 5, Content = "GPT-4o multimodal capabilities are impressive. Image-text understanding is highly accurate." },
                    }
                },

                //  Gemini 
                ["Gemini"] = new AIModel
                {
                    Name = "Gemini",
                    IconSource = ImageSource.FromFile("gemini.png"),
                    Company = "Google",
                    Slogan = "Google AI built for everyone",
                    Description = "Gemini is Google's latest multimodal model, deeply integrated with Google Search, Workspace, and other Google services. Known for lightning-fast responses and powerful real-time web access, ideal for scenarios requiring up-to-date information.",
                    ThemeColor = Color.FromArgb("#4A8EE8"),
                    ThemeColorDark = Color.FromArgb("#2C5FAA"),
                    Rating = 4.5,
                    ReviewCount = "31.6k",
                    Tags = new() { "Multimodal", "Web", "Code", "Speed", "Google" },

                    RadarReasoning = 85,
                    RadarWriting = 83,
                    RadarCode = 82,
                    RadarAnalysis = 88,
                    RadarMultilingual = 80,
                    RadarSpeed = 92,

                    UseCases = new()
                    {
                        new UseCase { Icon = "🔍", Title = "Real-time Search", Description = "Google-powered live data" },
                        new UseCase { Icon = "🎬", Title = "Video Understanding",Description = "Analyze video content" },
                        new UseCase { Icon = "⚡", Title = "Fast Responses",   Description = "Fastest among major models" },
                        new UseCase { Icon = "📧", Title = "Google Integration",Description = "Seamless Gmail & Docs access" },
                    },

                    ContextWindow = "1M tokens",
                    SupportedLanguages = "40+",
                    ResponseSpeed = "Very Fast",
                    SupportsWebSearch = true,
                    SupportsToolCall = true,
                    InputTypes = new() { "Text", "Image", "Video", "Audio" },

                    PricingPlans = new()
                    {
                        new PricingPlan { PlanName = "Free",     Price = "Gemini Flash",  IsHighlighted = false },
                        new PricingPlan { PlanName = "Advanced", Price = "$19.99 / month",IsHighlighted = true  },
                        new PricingPlan { PlanName = "API",      Price = "Pay as you go", IsHighlighted = false },
                    },

                    CompareItems = new()
                    {
                        new CompareItem { ModelName = "Gemini",  Code = 82, Writing = 83, Reasoning = 85, Speed = 92, BarColor = Color.FromArgb("#4A8EE8") },
                        new CompareItem { ModelName = "Claude",  Code = 85, Writing = 95, Reasoning = 92, Speed = 80, BarColor = Color.FromArgb("#C96442") },
                        new CompareItem { ModelName = "ChatGPT", Code = 88, Writing = 85, Reasoning = 88, Speed = 85, BarColor = Color.FromArgb("#10A37F") },
                    },
                    CompareNote = "Gemini wins on speed and multimodal breadth. Its 1M-token context is unmatched. Google ecosystem integration is the best available. Writing and reasoning trail competitors slightly.",

                    RatingDistribution = new() { 55, 28, 11, 4, 2 },
                    UserReviews = new()
                    {
                        new UserReview { UserName = "Sun**",  Score = 5, Content = "Blazing fast with accurate real-time search. Perfect for looking things up." },
                        new UserReview { UserName = "Zhou**", Score = 4, Content = "Smooth integration with Google Workspace tools. First choice for Workspace users." },
                        new UserReview { UserName = "Wu**",   Score = 4, Content = "The 1M context is incredible. Dropped an entire codebase in one go." },
                    }
                },

                //  DeepSeek 
                ["DeepSeek"] = new AIModel
                {
                    Name = "DeepSeek",
                    IconSource = ImageSource.FromFile("deep_seek.png"),
                    Company = "DeepSeek AI",
                    Slogan = "Open-source powerhouse from China",
                    Description = "DeepSeek is a high-performance open-source large language model from China, with top-tier code and mathematical reasoning capabilities at an exceptional price-to-performance ratio. Fully open-source and supports local deployment.",
                    ThemeColor = Color.FromArgb("#3B5EF8"),
                    ThemeColorDark = Color.FromArgb("#1A3AAA"),
                    Rating = 4.6,
                    ReviewCount = "22.8k",
                    Tags = new() { "Open-source", "Code", "Math", "Reasoning", "Self-hosted" },

                    RadarReasoning = 93,
                    RadarWriting = 78,
                    RadarCode = 95,
                    RadarAnalysis = 90,
                    RadarMultilingual = 75,
                    RadarSpeed = 82,

                    UseCases = new()
                    {
                        new UseCase { Icon = "💻", Title = "Code Generation",  Description = "Write and optimize code in any language" },
                        new UseCase { Icon = "🔢", Title = "Math Reasoning",   Description = "Solve complex mathematical problems" },
                        new UseCase { Icon = "🏠", Title = "Local Deployment", Description = "Self-hosted for full data privacy" },
                        new UseCase { Icon = "🔬", Title = "Research Aid",     Description = "Paper reading and formula derivation" },
                    },

                    ContextWindow = "64K tokens",
                    SupportedLanguages = "30+",
                    ResponseSpeed = "Medium",
                    SupportsWebSearch = false,
                    SupportsToolCall = true,
                    InputTypes = new() { "Text", "Code" },

                    PricingPlans = new()
                    {
                        new PricingPlan { PlanName = "Open Source", Price = "Free & self-hostable",  IsHighlighted = false },
                        new PricingPlan { PlanName = "API",         Price = "Extremely low per-token",IsHighlighted = true  },
                    },

                    CompareItems = new()
                    {
                        new CompareItem { ModelName = "DeepSeek", Code = 95, Writing = 78, Reasoning = 93, Speed = 82, BarColor = Color.FromArgb("#3B5EF8") },
                        new CompareItem { ModelName = "Claude",   Code = 85, Writing = 95, Reasoning = 92, Speed = 80, BarColor = Color.FromArgb("#C96442") },
                        new CompareItem { ModelName = "GPT-4o",   Code = 88, Writing = 87, Reasoning = 88, Speed = 85, BarColor = Color.FromArgb("#10A37F") },
                    },
                    CompareNote = "DeepSeek surpasses most commercial models in code and math while remaining fully open-source. Writing and multilingual capabilities are relatively weaker. Best suited for developers and researchers.",

                    RatingDistribution = new() { 60, 25, 10, 3, 2 },
                    UserReviews = new()
                    {
                        new UserReview { UserName = "Han**", Score = 5, Content = "Code quality is outstanding. Beats GPT-4 on algorithm problems." },
                        new UserReview { UserName = "Hu**",  Score = 5, Content = "Open-source and locally deployable — zero data privacy concerns." },
                        new UserReview { UserName = "Yang**",Score = 4, Content = "Chinese writing is slightly weaker, but math reasoning is flawless." },
                    }
                },

                //  Qwen 
                ["Qwen"] = new AIModel
                {
                    Name = "Qwen",
                    IconSource = ImageSource.FromFile("model_square.png"),
                    Company = "Alibaba Cloud",
                    Slogan = "Best-in-class Chinese language understanding",
                    Description = "Qwen (Tongyi Qianwen) is Alibaba Cloud's large language model series, excelling in Chinese comprehension and generation. Deeply integrated with the Alibaba ecosystem, supporting long text and multimodal inputs for enterprise use cases.",
                    ThemeColor = Color.FromArgb("#6B4BEB"),
                    ThemeColorDark = Color.FromArgb("#4A2DB0"),
                    Rating = 4.5,
                    ReviewCount = "18.3k",
                    Tags = new() { "Chinese", "Enterprise", "Multimodal", "Long context", "Alibaba" },

                    RadarReasoning = 85,
                    RadarWriting = 90,
                    RadarCode = 82,
                    RadarAnalysis = 86,
                    RadarMultilingual = 88,
                    RadarSpeed = 83,

                    UseCases = new()
                    {
                        new UseCase { Icon = "🀄", Title = "Chinese Writing",    Description = "Authoring, translation, proofreading" },
                        new UseCase { Icon = "🏢", Title = "Enterprise Apps",    Description = "Deep Alibaba Cloud integration" },
                        new UseCase { Icon = "📋", Title = "Document Summary",   Description = "Extract key points from long documents" },
                        new UseCase { Icon = "🖼️", Title = "Vision Understanding",Description = "Multimodal content analysis" },
                    },

                    ContextWindow = "128K tokens",
                    SupportedLanguages = "50+",
                    ResponseSpeed = "Fast",
                    SupportsWebSearch = true,
                    SupportsToolCall = true,
                    InputTypes = new() { "Text", "Image", "File" },

                    PricingPlans = new()
                    {
                        new PricingPlan { PlanName = "Free",       Price = "Qwen-Turbo",    IsHighlighted = false },
                        new PricingPlan { PlanName = "Pro",        Price = "Pay as you go", IsHighlighted = true  },
                        new PricingPlan { PlanName = "Enterprise", Price = "Contact sales",  IsHighlighted = false },
                    },

                    CompareItems = new()
                    {
                        new CompareItem { ModelName = "Qwen",    Code = 82, Writing = 90, Reasoning = 85, Speed = 83, BarColor = Color.FromArgb("#6B4BEB") },
                        new CompareItem { ModelName = "Claude",  Code = 85, Writing = 95, Reasoning = 92, Speed = 80, BarColor = Color.FromArgb("#C96442") },
                        new CompareItem { ModelName = "ChatGPT", Code = 88, Writing = 85, Reasoning = 88, Speed = 85, BarColor = Color.FromArgb("#10A37F") },
                    },
                    CompareNote = "Qwen leads in Chinese language tasks. Alibaba ecosystem integration is the top advantage for domestic enterprise users. Compliance and localized support are key reasons to choose Qwen.",

                    RatingDistribution = new() { 55, 27, 12, 4, 2 },
                    UserReviews = new()
                    {
                        new UserReview { UserName = "Lin**", Score = 5, Content = "Excellent Chinese understanding. High accuracy when handling contract documents." },
                        new UserReview { UserName = "Xu**",  Score = 4, Content = "Works seamlessly with other Alibaba Cloud products. Great choice for enterprise users." },
                        new UserReview { UserName = "He**",  Score = 4, Content = "Natural Chinese writing style. English capability slightly behind Claude and GPT." },
                    }
                },

                //  DouBao 
                ["DouBao"] = new AIModel
                {
                    Name = "DouBao",
                    IconSource = ImageSource.FromFile("doubao.png"),
                    Company = "ByteDance",
                    Slogan = "Friendly everyday AI at unbeatable value",
                    Description = "Doubao is ByteDance's AI assistant, known for its natural conversational tone and extremely competitive pricing. Deeply integrated with Douyin, Feishu, and other ByteDance products, ideal for everyday Q&A, content creation, and learning support.",
                    ThemeColor = Color.FromArgb("#FF6B35"),
                    ThemeColorDark = Color.FromArgb("#CC4A1A"),
                    Rating = 4.3,
                    ReviewCount = "45.1k",
                    Tags = new() { "Daily use", "Budget", "Content", "ByteDance", "Learning" },

                    RadarReasoning = 78,
                    RadarWriting = 85,
                    RadarCode = 72,
                    RadarAnalysis = 76,
                    RadarMultilingual = 80,
                    RadarSpeed = 90,

                    UseCases = new()
                    {
                        new UseCase { Icon = "💬", Title = "Casual Chat",      Description = "Light, natural conversation" },
                        new UseCase { Icon = "✍️", Title = "Content Creation", Description = "Short video scripts, social copy" },
                        new UseCase { Icon = "📖", Title = "Study Aid",        Description = "Homework help, knowledge Q&A" },
                        new UseCase { Icon = "🎵", Title = "ByteDance Apps",   Description = "Integrated with Douyin & Feishu" },
                    },

                    ContextWindow = "32K tokens",
                    SupportedLanguages = "20+",
                    ResponseSpeed = "Very Fast",
                    SupportsWebSearch = true,
                    SupportsToolCall = false,
                    InputTypes = new() { "Text", "Image" },

                    PricingPlans = new()
                    {
                        new PricingPlan { PlanName = "Free", Price = "Core features free",   IsHighlighted = false },
                        new PricingPlan { PlanName = "Pro",  Price = "¥9.9 / month",         IsHighlighted = true  },
                    },

                    CompareItems = new()
                    {
                        new CompareItem { ModelName = "DouBao",  Code = 72, Writing = 85, Reasoning = 78, Speed = 90, BarColor = Color.FromArgb("#FF6B35") },
                        new CompareItem { ModelName = "Qwen",    Code = 82, Writing = 90, Reasoning = 85, Speed = 83, BarColor = Color.FromArgb("#6B4BEB") },
                        new CompareItem { ModelName = "ChatGPT", Code = 88, Writing = 85, Reasoning = 88, Speed = 85, BarColor = Color.FromArgb("#10A37F") },
                    },
                    CompareNote = "Doubao wins on price and fluency, ideal for lightweight everyday use. Deep reasoning and code capabilities lag behind. Best for content creation and study assistance rather than technical tasks.",

                    RatingDistribution = new() { 45, 30, 16, 6, 3 },
                    UserReviews = new()
                    {
                        new UserReview { UserName = "Feng**",  Score = 5, Content = "Unbelievably affordable. More than enough for daily use. Incredible value." },
                        new UserReview { UserName = "Jiang**", Score = 4, Content = "Conversation feels very natural, almost like talking to a real person." },
                        new UserReview { UserName = "Shen**",  Score = 3, Content = "Lacks depth on complex topics, but perfectly fine for everyday needs." },
                    }
                },

                //  Grok 
                ["Grok"] = new AIModel
                {
                    Name = "Grok",
                    IconSource = ImageSource.FromFile("grok.png"),
                    Company = "xAI",
                    Slogan = "The witty AI with real-time X access",
                    Description = "Grok is the AI assistant developed by Elon Musk's xAI, featuring a distinctive witty personality and real-time access to X (formerly Twitter). Excels at current events discussion, creative content, and deep STEM Q&A.",
                    ThemeColor = Color.FromArgb("#888888"),
                    ThemeColorDark = Color.FromArgb("#555555"),
                    Rating = 4.2,
                    ReviewCount = "8.9k",
                    Tags = new() { "Real-time", "X Platform", "Humor", "STEM", "Creative" },

                    RadarReasoning = 85,
                    RadarWriting = 80,
                    RadarCode = 83,
                    RadarAnalysis = 82,
                    RadarMultilingual = 70,
                    RadarSpeed = 85,

                    UseCases = new()
                    {
                        new UseCase { Icon = "📰", Title = "News Analysis",    Description = "Real-time X platform insights" },
                        new UseCase { Icon = "😄", Title = "Creative Fun",     Description = "Witty conversation and humor" },
                        new UseCase { Icon = "🔭", Title = "STEM Q&A",         Description = "Physics and math deep-dives" },
                        new UseCase { Icon = "💡", Title = "Brainstorming",    Description = "Unconventional idea generation" },
                    },

                    ContextWindow = "128K tokens",
                    SupportedLanguages = "25+",
                    ResponseSpeed = "Fast",
                    SupportsWebSearch = true,
                    SupportsToolCall = false,
                    InputTypes = new() { "Text", "Image" },

                    PricingPlans = new()
                    {
                        new PricingPlan { PlanName = "X Premium+", Price = "$16 / month",   IsHighlighted = true  },
                        new PricingPlan { PlanName = "API",        Price = "Pay as you go",  IsHighlighted = false },
                    },

                    CompareItems = new()
                    {
                        new CompareItem { ModelName = "Grok",    Code = 83, Writing = 80, Reasoning = 85, Speed = 85, BarColor = Color.FromArgb("#888888") },
                        new CompareItem { ModelName = "Claude",  Code = 85, Writing = 95, Reasoning = 92, Speed = 80, BarColor = Color.FromArgb("#C96442") },
                        new CompareItem { ModelName = "ChatGPT", Code = 88, Writing = 85, Reasoning = 88, Speed = 85, BarColor = Color.FromArgb("#10A37F") },
                    },
                    CompareNote = "Grok's standout feature is real-time X platform access, unmatched for trending discussions. Overall capability is near mainstream level, with a unique witty tone that shines in casual conversation.",

                    RatingDistribution = new() { 42, 30, 18, 7, 3 },
                    UserReviews = new()
                    {
                        new UserReview { UserName = "Cao**", Score = 4, Content = "Real-time tweet analysis is killer. Perfect for discussing hot topics." },
                        new UserReview { UserName = "Wei**", Score = 4, Content = "Way more personality than other AIs. Replies have real character." },
                        new UserReview { UserName = "Xu**",  Score = 3, Content = "Average Chinese support. Better experienced in English." },
                    }
                },

                //  Kimi 
                ["Kimi"] = new AIModel
                {
                    Name = "Kimi",
                    IconSource = ImageSource.FromFile("kimi.png"),
                    Company = "Moonshot AI",
                    Slogan = "Ultra-long context that reads every page",
                    Description = "Kimi is the AI assistant from Moonshot AI, renowned for exceptional long-text processing. It can ingest entire books or large codebases in one go. Performs excellently in Chinese Q&A, document summarization, and academic support.",
                    ThemeColor = Color.FromArgb("#3D5A9E"),
                    ThemeColorDark = Color.FromArgb("#1E2F5A"),
                    Rating = 4.4,
                    ReviewCount = "19.7k",
                    Tags = new() { "Long context", "Documents", "Chinese", "Academic", "Summary" },

                    RadarReasoning = 82,
                    RadarWriting = 86,
                    RadarCode = 78,
                    RadarAnalysis = 88,
                    RadarMultilingual = 82,
                    RadarSpeed = 78,

                    UseCases = new()
                    {
                        new UseCase { Icon = "📄", Title = "Document Reading",  Description = "Upload PDF and get instant summary" },
                        new UseCase { Icon = "🎓", Title = "Academic Aid",      Description = "Paper analysis and literature review" },
                        new UseCase { Icon = "📝", Title = "Meeting Notes",     Description = "Transcribe audio and extract key points" },
                        new UseCase { Icon = "🔎", Title = "Full-text Search",  Description = "Pinpoint answers in huge documents" },
                    },

                    ContextWindow = "200K tokens",
                    SupportedLanguages = "40+",
                    ResponseSpeed = "Medium",
                    SupportsWebSearch = true,
                    SupportsToolCall = false,
                    InputTypes = new() { "Text", "PDF", "File" },

                    PricingPlans = new()
                    {
                        new PricingPlan { PlanName = "Free", Price = "Basic features",  IsHighlighted = false },
                        new PricingPlan { PlanName = "Pro",  Price = "¥99 / month",     IsHighlighted = true  },
                        new PricingPlan { PlanName = "API",  Price = "Pay as you go",   IsHighlighted = false },
                    },

                    CompareItems = new()
                    {
                        new CompareItem { ModelName = "Kimi",   Code = 78, Writing = 86, Reasoning = 82, Speed = 78, BarColor = Color.FromArgb("#3D5A9E") },
                        new CompareItem { ModelName = "Claude", Code = 85, Writing = 95, Reasoning = 92, Speed = 80, BarColor = Color.FromArgb("#C96442") },
                        new CompareItem { ModelName = "Qwen",   Code = 82, Writing = 90, Reasoning = 85, Speed = 83, BarColor = Color.FromArgb("#6B4BEB") },
                    },
                    CompareNote = "Kimi excels at long-context document processing. Its 200K-token support is unbeatable for academic and office workflows. General reasoning and code trail Claude, but it is the top pick for heavy document users.",

                    RatingDistribution = new() { 50, 28, 14, 5, 3 },
                    UserReviews = new()
                    {
                        new UserReview { UserName = "Zheng**", Score = 5, Content = "Threw in a 300-page PDF and got an accurate summary. Absolutely incredible." },
                        new UserReview { UserName = "Dong**",  Score = 4, Content = "Academic paper reading assistant is excellent. Huge productivity boost." },
                        new UserReview { UserName = "Yuan**",  Score = 4, Content = "Strong Chinese comprehension. Processing Chinese documents is nearly flawless." },
                    }
                },
            };
        }
    }
}
