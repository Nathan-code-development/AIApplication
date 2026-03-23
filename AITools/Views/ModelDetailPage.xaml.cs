using AITools.Models;
using Microsoft.Maui.Controls;
using Microsoft.Maui.Controls.Shapes;
using Microsoft.Maui.Graphics;
using Microsoft.Maui.Layouts;
using System;
using System.Collections.Generic;

namespace AITools.Views
{
    public partial class ModelDetailPage : ContentPage
    {
        private readonly AIModel _model;
        private bool _liked = false;

        // Maps tab key -> its Button, used to reset active state
        private readonly Dictionary<string, Button> _tabButtons;

        public ModelDetailPage(AIModel model)
        {
            InitializeComponent();
            _model = model;

            _tabButtons = new Dictionary<string, Button>
            {
                ["overview"] = TabOverview,
                ["specs"] = TabSpecs,
                ["compare"] = TabCompare,
                ["reviews"] = TabReviews,
            };

            BindHero();
            SetActiveTab("overview");
        }

        // Hero section data binding 
        private void BindHero()
        {
            HeroBanner.Background = new LinearGradientBrush
            {
                StartPoint = new Point(0, 0),
                EndPoint = new Point(1, 1),
                GradientStops =
                {
                    new GradientStop { Color = _model.ThemeColor,     Offset = 0f },
                    new GradientStop { Color = _model.ThemeColorDark, Offset = 1f }
                }
            };

            HeroIcon.Source = _model.IconSource;
            HeroName.Text = _model.Name;
            HeroCompany.Text = _model.Company;
            HeroSlogan.Text = _model.Slogan;

            int full = (int)Math.Floor(_model.Rating);
            HeroStars.Text = new string('★', full) + new string('☆', 5 - full);
            HeroRating.Text = $"{_model.Rating}  ({_model.ReviewCount} reviews)";

            CtaButton.Background = new LinearGradientBrush
            {
                StartPoint = new Point(0, 0),
                EndPoint = new Point(1, 0),
                GradientStops =
                {
                    new GradientStop { Color = _model.ThemeColor,     Offset = 0f },
                    new GradientStop { Color = _model.ThemeColorDark, Offset = 1f }
                }
            };

            HeroTagsLayout.Children.Clear();
            foreach (var tag in _model.Tags)
            {
                HeroTagsLayout.Children.Add(new Border
                {
                    BackgroundColor = Color.FromRgba(255, 255, 255, 42),
                    Stroke = Color.FromRgba(255, 255, 255, 60),
                    StrokeThickness = 1,
                    StrokeShape = new RoundRectangle { CornerRadius = 20 },
                    Padding = new Thickness(10, 3),
                    Margin = new Thickness(0, 0, 6, 6),
                    Content = new Label
                    {
                        Text = tag,
                        FontSize = 11,
                        TextColor = Colors.White
                    }
                });
            }

            TabIndicator.Color = _model.ThemeColor;
        }

        // Tab switching
        private void OnTabClicked(object sender, EventArgs e)
        {
            if (sender is Button btn && btn.CommandParameter is string tab)
                SetActiveTab(tab);
        }

        private void SetActiveTab(string tab)
        {
            // Reset all tab buttons
            foreach (var kv in _tabButtons)
            {
                kv.Value.TextColor = Color.FromArgb("#556677");
                kv.Value.FontAttributes = FontAttributes.None;
            }

            // Activate selected tab
            if (_tabButtons.TryGetValue(tab, out Button? activeBtn))
            {
                activeBtn.TextColor = Colors.White;
                activeBtn.FontAttributes = FontAttributes.Bold;
            }

            // Move indicator underline to selected column
            int colIndex = tab switch
            {
                "overview" => 0,
                "specs" => 1,
                "compare" => 2,
                "reviews" => 3,
                _ => 0
            };
            Grid.SetColumn(TabIndicator, colIndex);

            ContentArea.Children.Clear();
            switch (tab)
            {
                case "overview": RenderOverview(); break;
                case "specs": RenderSpecs(); break;
                case "compare": RenderCompare(); break;
                case "reviews": RenderReviews(); break;
            }
        }

        // Helper: section title row with colored left bar
        private View MakeSectionTitle(string title)
        {
            return new HorizontalStackLayout
            {
                Spacing = 8,
                Margin = new Thickness(0, 0, 0, 10),
                Children =
                {
                    new BoxView
                    {
                        Color           = _model.ThemeColor,
                        WidthRequest    = 3,
                        HeightRequest   = 14,
                        CornerRadius    = 2,
                        VerticalOptions = LayoutOptions.Center
                    },
                    new Label
                    {
                        Text                  = title,
                        FontSize              = 14,
                        FontAttributes        = FontAttributes.Bold,
                        TextColor             = Colors.White,
                        VerticalTextAlignment = TextAlignment.Center
                    }
                }
            };
        }

        // Helper: thin horizontal divider
        private static BoxView MakeDivider() => new BoxView
        {
            Color = Color.FromArgb("#2A2A38"),
            HeightRequest = 0.5
        };

        // Tab: Overview
        private void RenderOverview()
        {
            // Description
            ContentArea.Children.Add(MakeSectionTitle("About"));
            ContentArea.Children.Add(new Label
            {
                Text = _model.Description,
                FontSize = 13,
                TextColor = Color.FromArgb("#AABBCC"),
                LineBreakMode = LineBreakMode.WordWrap,
                Margin = new Thickness(0, 0, 0, 24)
            });

            // Capability radar (rendered as labeled progress bars)
            ContentArea.Children.Add(MakeSectionTitle("Capability Radar"));

            var radarData = new (string Label, int Value)[]
            {
                ("Reasoning",    _model.RadarReasoning),
                ("Writing",      _model.RadarWriting),
                ("Code",         _model.RadarCode),
                ("Analysis",     _model.RadarAnalysis),
                ("Multilingual", _model.RadarMultilingual),
                ("Speed",        _model.RadarSpeed),
            };

            var radarCard = new Border
            {
                BackgroundColor = Color.FromArgb("#1C1C24"),
                Stroke = Color.FromArgb("#2A2A38"),
                StrokeThickness = 1,
                StrokeShape = new RoundRectangle { CornerRadius = 12 },
                Padding = new Thickness(16),
                Margin = new Thickness(0, 0, 0, 24)
            };

            var radarStack = new VerticalStackLayout { Spacing = 10 };
            foreach (var (label, value) in radarData)
            {
                var row = new Grid
                {
                    ColumnDefinitions =
                    {
                        new ColumnDefinition { Width = 90 },
                        new ColumnDefinition(),
                        new ColumnDefinition { Width = 36 }
                    },
                    ColumnSpacing = 10
                };

                row.Add(new Label
                {
                    Text = label,
                    FontSize = 12,
                    TextColor = Color.FromArgb("#AABBCC"),
                    VerticalTextAlignment = TextAlignment.Center
                }, 0);

                row.Add(new ProgressBar
                {
                    Progress = value / 100.0,
                    ProgressColor = _model.ThemeColor,
                    BackgroundColor = Color.FromArgb("#2A2A38"),
                    HeightRequest = 8,
                    VerticalOptions = LayoutOptions.Center
                }, 1);

                row.Add(new Label
                {
                    Text = value.ToString(),
                    FontSize = 12,
                    FontAttributes = FontAttributes.Bold,
                    TextColor = _model.ThemeColor,
                    HorizontalTextAlignment = TextAlignment.End,
                    VerticalTextAlignment = TextAlignment.Center
                }, 2);

                radarStack.Children.Add(row);
            }

            radarCard.Content = radarStack;
            ContentArea.Children.Add(radarCard);

            // Use cases 2-column grid
            ContentArea.Children.Add(MakeSectionTitle("Use Cases"));

            var usecaseGrid = new Grid
            {
                ColumnDefinitions = { new ColumnDefinition(), new ColumnDefinition() },
                RowSpacing = 10,
                ColumnSpacing = 10,
                Margin = new Thickness(0, 0, 0, 24)
            };

            for (int i = 0; i < _model.UseCases.Count; i++)
            {
                var uc = _model.UseCases[i];
                var card = new Border
                {
                    BackgroundColor = Color.FromArgb("#1C1C24"),
                    Stroke = Color.FromArgb("#2A2A38"),
                    StrokeThickness = 1,
                    StrokeShape = new RoundRectangle { CornerRadius = 12 },
                    Padding = new Thickness(12)
                };
                card.Content = new VerticalStackLayout
                {
                    Spacing = 4,
                    Children =
                    {
                        new Label { Text = uc.Icon,        FontSize = 22 },
                        new Label { Text = uc.Title,       FontSize = 13, FontAttributes = FontAttributes.Bold, TextColor = Colors.White },
                        new Label { Text = uc.Description, FontSize = 11, TextColor = Color.FromArgb("#556677"), LineBreakMode = LineBreakMode.WordWrap }
                    }
                };
                usecaseGrid.Add(card, i % 2, i / 2);
            }

            ContentArea.Children.Add(usecaseGrid);
        }

        // Tab: Specs
        private void RenderSpecs()
        {
            ContentArea.Children.Add(MakeSectionTitle("Technical Specs"));

            var specItems = new (string Icon, string Label, string Value)[]
            {
                ("📐", "Context Window",   _model.ContextWindow),
                ("🌐", "Languages",        _model.SupportedLanguages),
                ("⚡", "Response Speed",   _model.ResponseSpeed),
                ("🔗", "Web Search",       _model.SupportsWebSearch  ? "Supported" : "Not supported"),
                ("🛠️","Tool Calling",      _model.SupportsToolCall   ? "Supported" : "Not supported"),
            };

            var specCard = new Border
            {
                BackgroundColor = Color.FromArgb("#1C1C24"),
                Stroke = Color.FromArgb("#2A2A38"),
                StrokeThickness = 1,
                StrokeShape = new RoundRectangle { CornerRadius = 12 },
                Padding = new Thickness(16, 8),
                Margin = new Thickness(0, 0, 0, 24)
            };

            var specStack = new VerticalStackLayout { Spacing = 0 };
            for (int i = 0; i < specItems.Length; i++)
            {
                var (icon, label, value) = specItems[i];
                var row = new Grid
                {
                    ColumnDefinitions =
                    {
                        new ColumnDefinition { Width = GridLength.Auto },
                        new ColumnDefinition(),
                        new ColumnDefinition { Width = GridLength.Auto }
                    },
                    ColumnSpacing = 10,
                    Padding = new Thickness(0, 12)
                };
                row.Add(new Label { Text = icon, FontSize = 16, VerticalTextAlignment = TextAlignment.Center }, 0);
                row.Add(new Label { Text = label, FontSize = 12.5, TextColor = Color.FromArgb("#AABBCC"), VerticalTextAlignment = TextAlignment.Center }, 1);
                row.Add(new Label { Text = value, FontSize = 12.5, FontAttributes = FontAttributes.Bold, TextColor = Colors.White, HorizontalTextAlignment = TextAlignment.End, VerticalTextAlignment = TextAlignment.Center }, 2);
                specStack.Children.Add(row);
                if (i < specItems.Length - 1) specStack.Children.Add(MakeDivider());
            }

            specCard.Content = specStack;
            ContentArea.Children.Add(specCard);

            // Input types tag row
            ContentArea.Children.Add(MakeSectionTitle("Input Types"));
            var inputRow = new FlexLayout
            {
                Wrap = FlexWrap.Wrap,
                Direction = FlexDirection.Row,
                Margin = new Thickness(0, 0, 0, 24)
            };

            foreach (var inp in _model.InputTypes)
            {
                inputRow.Children.Add(new Border
                {
                    BackgroundColor = Color.FromRgba(_model.ThemeColor.Red, _model.ThemeColor.Green, _model.ThemeColor.Blue, 0.13f),
                    Stroke = Color.FromRgba(_model.ThemeColor.Red, _model.ThemeColor.Green, _model.ThemeColor.Blue, 0.4f),
                    StrokeThickness = 1,
                    StrokeShape = new RoundRectangle { CornerRadius = 20 },
                    Padding = new Thickness(14, 5),
                    Margin = new Thickness(0, 0, 8, 8),
                    Content = new Label { Text = inp, FontSize = 12, TextColor = _model.ThemeColor }
                });
            }
            ContentArea.Children.Add(inputRow);

            // Pricing plans
            ContentArea.Children.Add(MakeSectionTitle("Pricing"));
            foreach (var plan in _model.PricingPlans)
            {
                bool isH = plan.IsHighlighted;
                ContentArea.Children.Add(new Border
                {
                    BackgroundColor = isH
                        ? Color.FromRgba(_model.ThemeColor.Red, _model.ThemeColor.Green, _model.ThemeColor.Blue, 0.1f)
                        : Color.FromArgb("#1C1C24"),
                    Stroke = isH
                        ? Color.FromRgba(_model.ThemeColor.Red, _model.ThemeColor.Green, _model.ThemeColor.Blue, 0.4f)
                        : Color.FromArgb("#2A2A38"),
                    StrokeThickness = 1,
                    StrokeShape = new RoundRectangle { CornerRadius = 12 },
                    Padding = new Thickness(16, 13),
                    Margin = new Thickness(0, 0, 0, 8),
                    Content = BuildPricingRow(plan.PlanName, plan.Price, isH)
                });
            }
        }

        // Tab: Compare
        private void RenderCompare()
        {
            ContentArea.Children.Add(MakeSectionTitle("Model Comparison"));

            // Color legend
            var legend = new HorizontalStackLayout { Spacing = 14, Margin = new Thickness(0, 0, 0, 14) };
            foreach (var ci in _model.CompareItems)
            {
                legend.Children.Add(new HorizontalStackLayout
                {
                    Spacing = 5,
                    Children =
                    {
                        new BoxView { Color = ci.BarColor, WidthRequest = 10, HeightRequest = 10, CornerRadius = 2, VerticalOptions = LayoutOptions.Center },
                        new Label   { Text  = ci.ModelName, FontSize = 11, TextColor = ci.BarColor }
                    }
                });
            }
            ContentArea.Children.Add(legend);

            var metrics = new (string Label, Func<CompareItem, int> GetValue)[]
            {
                ("Code",      ci => ci.Code),
                ("Writing",   ci => ci.Writing),
                ("Reasoning", ci => ci.Reasoning),
                ("Speed",     ci => ci.Speed),
            };

            var compareCard = new Border
            {
                BackgroundColor = Color.FromArgb("#1C1C24"),
                Stroke = Color.FromArgb("#2A2A38"),
                StrokeThickness = 1,
                StrokeShape = new RoundRectangle { CornerRadius = 12 },
                Padding = new Thickness(16),
                Margin = new Thickness(0, 0, 0, 16)
            };

            var compareStack = new VerticalStackLayout { Spacing = 14 };
            foreach (var (metricLabel, getValue) in metrics)
            {
                compareStack.Children.Add(new Label
                {
                    Text = metricLabel,
                    FontSize = 11,
                    TextColor = Color.FromArgb("#556677"),
                    Margin = new Thickness(0, 0, 0, 4)
                });

                foreach (var ci in _model.CompareItems)
                {
                    int val = getValue(ci);
                    var barRow = new Grid
                    {
                        ColumnDefinitions =
                        {
                            new ColumnDefinition { Width = 52 },
                            new ColumnDefinition(),
                            new ColumnDefinition { Width = 28 }
                        },
                        ColumnSpacing = 8,
                        Margin = new Thickness(0, 0, 0, 3)
                    };
                    barRow.Add(new Label { Text = ci.ModelName, FontSize = 10, TextColor = Color.FromArgb("#AABBCC"), HorizontalTextAlignment = TextAlignment.End, VerticalTextAlignment = TextAlignment.Center }, 0);
                    barRow.Add(new ProgressBar { Progress = val / 100.0, ProgressColor = ci.BarColor, BackgroundColor = Color.FromArgb("#2A2A38"), HeightRequest = 7, VerticalOptions = LayoutOptions.Center }, 1);
                    barRow.Add(new Label { Text = val.ToString(), FontSize = 10, TextColor = Color.FromArgb("#AABBCC"), HorizontalTextAlignment = TextAlignment.End, VerticalTextAlignment = TextAlignment.Center }, 2);
                    compareStack.Children.Add(barRow);
                }
            }

            compareCard.Content = compareStack;
            ContentArea.Children.Add(compareCard);

            // Summary note card
            ContentArea.Children.Add(new Border
            {
                BackgroundColor = Color.FromRgba(_model.ThemeColor.Red, _model.ThemeColor.Green, _model.ThemeColor.Blue, 0.09f),
                Stroke = Color.FromRgba(_model.ThemeColor.Red, _model.ThemeColor.Green, _model.ThemeColor.Blue, 0.3f),
                StrokeThickness = 1,
                StrokeShape = new RoundRectangle { CornerRadius = 12 },
                Padding = new Thickness(14),
                Content = new VerticalStackLayout
                {
                    Spacing = 6,
                    Children =
                    {
                        new Label { Text = "💡 Summary", FontSize = 13, FontAttributes = FontAttributes.Bold, TextColor = Colors.White },
                        new Label { Text = _model.CompareNote, FontSize = 12.5, TextColor = Color.FromArgb("#AABBCC"), LineBreakMode = LineBreakMode.WordWrap }
                    }
                }
            });
        }

        // Tab: Reviews
        private void RenderReviews()
        {
            ContentArea.Children.Add(MakeSectionTitle("User Ratings"));

            var ratingCard = new Border
            {
                BackgroundColor = Color.FromArgb("#1C1C24"),
                Stroke = Color.FromArgb("#2A2A38"),
                StrokeThickness = 1,
                StrokeShape = new RoundRectangle { CornerRadius = 12 },
                Padding = new Thickness(16),
                Margin = new Thickness(0, 0, 0, 24)
            };

            var ratingGrid = new Grid
            {
                ColumnDefinitions = { new ColumnDefinition { Width = GridLength.Auto }, new ColumnDefinition() },
                ColumnSpacing = 16
            };

            // Left: large rating number
            ratingGrid.Add(new VerticalStackLayout
            {
                HorizontalOptions = LayoutOptions.Center,
                VerticalOptions = LayoutOptions.Center,
                Children =
                {
                    new Label { Text = _model.Rating.ToString("F1"), FontSize = 42, FontAttributes = FontAttributes.Bold, TextColor = Color.FromArgb("#FFB800"), HorizontalTextAlignment = TextAlignment.Center },
                    new Label { Text = new string('★', (int)Math.Round(_model.Rating)), FontSize = 14, TextColor = Color.FromArgb("#FFB800"), HorizontalTextAlignment = TextAlignment.Center },
                    new Label { Text = $"{_model.ReviewCount} reviews", FontSize = 11, TextColor = Color.FromArgb("#556677"), HorizontalTextAlignment = TextAlignment.Center, Margin = new Thickness(0, 3, 0, 0) }
                }
            }, 0);

            // Right: distribution bars (5 star to 1 star)
            int[] dist = _model.RatingDistribution.Count == 5
                ? _model.RatingDistribution.ToArray()
                : new[] { 0, 0, 0, 0, 0 };

            var distStack = new VerticalStackLayout { Spacing = 5, VerticalOptions = LayoutOptions.Center };
            for (int i = 0; i < 5; i++)
            {
                int star = 5 - i;
                int pct = dist[i];
                var distRow = new Grid
                {
                    ColumnDefinitions =
                    {
                        new ColumnDefinition { Width = 10 },
                        new ColumnDefinition(),
                        new ColumnDefinition { Width = 28 }
                    },
                    ColumnSpacing = 6
                };
                distRow.Add(new Label { Text = star.ToString(), FontSize = 10, TextColor = Color.FromArgb("#556677"), VerticalTextAlignment = TextAlignment.Center }, 0);
                distRow.Add(new ProgressBar { Progress = pct / 100.0, ProgressColor = Color.FromArgb("#FFB800"), BackgroundColor = Color.FromArgb("#2A2A38"), HeightRequest = 5, VerticalOptions = LayoutOptions.Center }, 1);
                distRow.Add(new Label { Text = $"{pct}%", FontSize = 9, TextColor = Color.FromArgb("#556677"), HorizontalTextAlignment = TextAlignment.End, VerticalTextAlignment = TextAlignment.Center }, 2);
                distStack.Children.Add(distRow);
            }
            ratingGrid.Add(distStack, 1);
            ratingCard.Content = ratingGrid;
            ContentArea.Children.Add(ratingCard);

            // Review cards
            ContentArea.Children.Add(MakeSectionTitle("Latest Reviews"));
            foreach (var rev in _model.UserReviews)
            {
                ContentArea.Children.Add(new Border
                {
                    BackgroundColor = Color.FromArgb("#1C1C24"),
                    Stroke = Color.FromArgb("#2A2A38"),
                    StrokeThickness = 1,
                    StrokeShape = new RoundRectangle { CornerRadius = 12 },
                    Padding = new Thickness(14),
                    Margin = new Thickness(0, 0, 0, 10),
                    Content = new VerticalStackLayout
                    {
                        Spacing = 8,
                        Children =
                        {
                            BuildReviewHeader(rev),
                            new Label
                            {
                                Text          = rev.Content,
                                FontSize      = 12.5,
                                TextColor     = Color.FromArgb("#AABBCC"),
                                LineBreakMode = LineBreakMode.WordWrap
                            }
                        }
                    }
                });
            }
        }

        // Helper: pricing plan row (Grid.SetColumn avoids CS0021) 
        private Grid BuildPricingRow(string planName, string price, bool isHighlighted)
        {
            var nameLabel = new Label
            {
                Text = planName,
                FontSize = 13,
                FontAttributes = isHighlighted ? FontAttributes.Bold : FontAttributes.None,
                TextColor = Colors.White,
                VerticalTextAlignment = TextAlignment.Center
            };
            var priceLabel = new Label
            {
                Text = price,
                FontSize = 13,
                TextColor = isHighlighted ? _model.ThemeColor : Color.FromArgb("#AABBCC"),
                HorizontalTextAlignment = TextAlignment.End,
                VerticalTextAlignment = TextAlignment.Center
            };
            var grid = new Grid
            {
                ColumnDefinitions =
                {
                    new ColumnDefinition(),
                    new ColumnDefinition { Width = GridLength.Auto }
                }
            };
            Grid.SetColumn(nameLabel, 0);
            Grid.SetColumn(priceLabel, 1);
            grid.Children.Add(nameLabel);
            grid.Children.Add(priceLabel);
            return grid;
        }

        // Helper: review card header row (Grid.SetColumn avoids CS0021) 
        private Grid BuildReviewHeader(UserReview rev)
        {
            var avatar = new Border
            {
                BackgroundColor = Color.FromRgba(_model.ThemeColor.Red, _model.ThemeColor.Green, _model.ThemeColor.Blue, 0.3f),
                StrokeThickness = 0,
                StrokeShape = new RoundRectangle { CornerRadius = 15 },
                WidthRequest = 30,
                HeightRequest = 30,
                Content = new Label
                {
                    Text = "👤",
                    FontSize = 14,
                    HorizontalTextAlignment = TextAlignment.Center,
                    VerticalTextAlignment = TextAlignment.Center
                }
            };
            var nameLabel = new Label
            {
                Text = rev.UserName,
                FontSize = 13,
                FontAttributes = FontAttributes.Bold,
                TextColor = Colors.White,
                VerticalTextAlignment = TextAlignment.Center
            };
            var starsLabel = new Label
            {
                Text = rev.Stars,
                FontSize = 12,
                TextColor = Color.FromArgb("#FFB800"),
                VerticalTextAlignment = TextAlignment.Center,
                HorizontalTextAlignment = TextAlignment.End
            };
            var grid = new Grid
            {
                ColumnDefinitions =
                {
                    new ColumnDefinition { Width = GridLength.Auto },
                    new ColumnDefinition(),
                    new ColumnDefinition { Width = GridLength.Auto }
                },
                ColumnSpacing = 8
            };
            Grid.SetColumn(avatar, 0);
            Grid.SetColumn(nameLabel, 1);
            Grid.SetColumn(starsLabel, 2);
            grid.Children.Add(avatar);
            grid.Children.Add(nameLabel);
            grid.Children.Add(starsLabel);
            return grid;
        }

        // Button event handlers 
        private async void OnBackClicked(object sender, EventArgs e)
        {
            // Page is presented modally, so use PopModalAsync to dismiss
            await Application.Current!.Windows[0].Page!.Navigation.PopModalAsync();
        }

        private void OnLikeClicked(object sender, EventArgs e)
        {
            _liked = !_liked;
            LikeButton.Text = _liked ? "♥" : "♡";
            LikeButton.TextColor = _liked ? Color.FromArgb("#FF6B6B") : Colors.White;
        }
    }
}