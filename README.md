# AI Tools - .NET MAUI Multi-Model Chat Application

AI Tools is a cross-platform mobile application built with **.NET MAUI** that provides a unified interface to interact with multiple AI models including **DeepSeek**, **Doubao**, and **Qwen**. It supports text conversations, image and file attachments, user authentication, profile management, chat history persistence, and a model showcase gallery.

## 📱 Features

- **Multi‑Model Chat** – Switch seamlessly between DeepSeek, Doubao, and Qwen.
- **Rich Attachments** – Send images (supported by Doubao & Qwen) and text files (e.g., PDF, TXT, JSON) as context.
- **Chat History** – Conversations are automatically saved and grouped into topics. Browse all past topics and continue any conversation.
- **User Authentication** – Register with email verification code, login, and manage your personal profile.
- **Profile Management** – Upload avatar, set display name, gender, bio, and phone number.
- **Model Square** – Browse 8 popular AI models (Claude, ChatGPT, Gemini, DeepSeek, Qwen, Doubao, Grok, Kimi) with detailed specs, capability radar, pricing, and user reviews.
- **Secure API Integration** – All API keys are stored on the client (for demonstration). For production, use a backend proxy to keep keys secure.

## 🛠️ Tech Stack

| Technology           | Purpose                                                      |
| :------------------- | :----------------------------------------------------------- |
| **.NET MAUI**        | Cross‑platform UI framework                                  |
| **C#**               | Backend logic and service layer                              |
| **HttpClient**       | REST API communication with backend server                   |
| **System.Text.Json** | JSON serialization / deserialization                         |
| **Preferences**      | Local storage for session data (login state, user info, avatar cache) |
| **MediaPicker**      | Pick images from gallery for avatar upload and chat attachments |
| **FilePicker**       | Attach any file to chat messages                             |

## 🧩 Backend Dependencies

This app expects a backend server with the following endpoints (Spring Boot based):

- **Authentication**
  `GET /Users/selectByUsername?username=xxx`
  `POST /Users/insertUser`
- **Chat**
  `GET /Topics/selectByUserId?userId=xxx`
  `POST /Topics/insertTopics`
  `GET /Topics/incrementMessageCount?id=xxx`
  `POST /ChatMessage/insertChatMessages`
  `GET /ChatMessage/selectByTopicId?topicId=xxx`
  `GET /ChatMessage/deleteByTopicId?topicId=xxx`
  `GET /Topics/deleteByUserId?userId=xxx`
- **Email Verification**
  `POST /api/v1/email/send-code`
  `POST /api/v1/email/verify-code`
- **User Profile & Avatar**
  `POST /UserProfiles/insertUserProfiles`
  `GET /UserProfiles/selectById?userId=xxx`
  `POST /UserProfiles/upload` (multipart/form-data)
  `GET /UserProfiles/addHeadImage?userId=xxx&avatarUrl=xxx`
  `GET /UserProfiles/download?name=xxx`

The backend base URL is configured in `ApiConfig.cs` (default: `http://www.nathanwebsite.com:380`). Replace it with your own server address.

## 🚀 Getting Started

### Prerequisites

- [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0) or later
- Visual Studio 2022 (17.8+) / VS Code with MAUI workloads
- Android/iOS/macOS/Windows development environment (depending on your target)

### Clone the Repository

```bash
git clone https://github.com/Nathan-code-development/AIApplication.git
cd AITools
```

### Configure API Keys (Important)

The file `Services/AiApiService.cs` contains hardcoded API keys for demonstration. **Do not commit real keys to GitHub.** Instead, replace them with your own keys or use a secure configuration system.

```csharp
private const string DeepSeekApiKey = "your-deepseek-key";
private const string DoubaoApiKey = "your-doubao-key";
private const string QianwenApiKey = "your-qianwen-key";
```

Alternatively, move keys to `appsettings.json` and use a configuration builder.

### Update Backend URL

Edit `Services/ApiConfig.cs`:

```csharp
public const string BaseUrl = "http://your-server-address:port";
```

### Build and Run

- Open the solution in Visual Studio
- Select a target (e.g., Android Emulator, Windows Machine)
- Press **F5** to debug

## 📁 Project Structure

```text
AITools/
├── Models/
│   └── AIModel.cs                 # Data models for model square
├── Services/
│   ├── AiApiService.cs            # AI API calls (DeepSeek, Doubao, Qwen)
│   ├── ApiConfig.cs               # Backend URL & JSON options
│   ├── AuthService.cs             # Login / Register
│   ├── ChatApiService.cs          # Topics & messages CRUD
│   ├── EmailCodeService.cs        # Email verification
│   └── UserProfileService.cs      # Profile & avatar management
├── Views/
│   ├── AI.xaml/.cs                # Main chat page
│   ├── AllTopicsPage.xaml/.cs     # List of all conversation topics
│   ├── CompleteProfilePage.xaml/.cs
│   ├── LoginPage.xaml/.cs
│   ├── ModelDetailPage.xaml/.cs   # Detailed model view
│   ├── modelSquare.xaml/.cs       # Model gallery
│   ├── Myself.xaml/.cs            # User profile & settings
│   └── RegisterPage.xaml/.cs
├── App.xaml/.cs
├── AppShell.xaml/.cs
└── Resources/                     # Images, styles, fonts
```

## 🔒 Security Notes

- **API keys** are currently hardcoded – only use this approach for personal/local testing.
- For production, move keys to a secure backend proxy or use Azure Key Vault / environment variables.
- Passwords are compared as plain text in the current demo backend. In a real application, always hash passwords.

## 📄 License

This project is licensed under the MIT License – see the [LICENSE](https://license/) file for details.

## 🙏 Acknowledgements

- [DeepSeek API](https://platform.deepseek.com/)
- [Doubao (ByteDance)](https://www.volcengine.com/product/doubao)
- [Qwen (Alibaba Cloud)](https://dashscope.aliyun.com/)
- .NET MAUI community

