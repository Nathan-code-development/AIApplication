using System.Collections.Generic;
using Microsoft.Maui.Controls;

namespace AITools.Views
{
    public partial class modelSquare : ContentPage
    {
        public modelSquare()
        {
            InitializeComponent();

            var models = new List<AIModel>{
                new AIModel { Name = "DeepSeek", IconSource = ImageSource.FromFile("deep_seek.png") },
                new AIModel { Name = "Qwen", IconSource = ImageSource.FromFile("model_square.png") },
                new AIModel { Name = "ChatGPT", IconSource = ImageSource.FromFile("chat_gpt.png") },
                new AIModel { Name = "DouBao", IconSource = ImageSource.FromFile("doubao.png") },
                new AIModel { Name = "Gemini", IconSource = ImageSource.FromFile("gemini.png") },
                new AIModel { Name = "Claude", IconSource = ImageSource.FromFile("claude.png") },
                new AIModel { Name = "Grok", IconSource = ImageSource.FromFile("grok.png") },
                new AIModel { Name = "Kimi", IconSource = ImageSource.FromFile("kimi.png") }
            };

            ModelsCollectionView.ItemsSource = models;
        }
    }
}