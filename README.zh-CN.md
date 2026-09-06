<div align="center">

# AI Tools

**基于 .NET MAUI 的多模型 AI 聊天应用**

[English](README.md) | **简体中文**

</div>

---

AI Tools 是一款使用 **.NET MAUI** 构建的跨平台移动应用，提供统一的界面来调用多个 AI 大模型，包括 **DeepSeek**、**豆包（Doubao）** 和 **通义千问（Qwen）**。应用支持文本对话、图片与文件附件、用户注册登录、个人资料管理、聊天记录持久化以及模型广场展示。

## 📱 功能特性

- **多模型对话** —— 在 DeepSeek、豆包、通义千问之间无缝切换。
- **富附件支持** —— 可发送图片（豆包与通义千问支持）以及文本文件（如 PDF、TXT、JSON）作为上下文。
- **聊天记录** —— 对话自动保存并按话题分组，可浏览全部历史话题并继续任意一段对话。
- **用户认证** —— 支持邮箱验证码注册、登录以及个人资料管理。
- **资料管理** —— 上传头像，设置昵称、性别、个性签名和手机号。
- **模型广场** —— 浏览 8 个热门 AI 模型（Claude、ChatGPT、Gemini、DeepSeek、Qwen、豆包、Grok、Kimi），查看详细参数、能力雷达图、定价与用户评价。
- **API 集成** —— 目前所有 API Key 均保存在客户端（仅用于演示）。生产环境请使用后端代理来保管密钥。

## 🛠️ 技术栈

| 技术                 | 用途                                                |
| :------------------- | :-------------------------------------------------- |
| **.NET MAUI**        | 跨平台 UI 框架                                      |
| **C#**               | 业务逻辑与服务层                                    |
| **HttpClient**       | 与后端服务器进行 REST API 通信                      |
| **System.Text.Json** | JSON 序列化 / 反序列化                              |
| **Preferences**      | 本地存储会话数据（登录状态、用户信息、头像缓存）    |
| **MediaPicker**      | 从相册选择图片，用于头像上传和聊天附件              |
| **FilePicker**       | 为聊天消息添加任意文件附件                          |

## 🧩 后端依赖

本应用需要配合一个提供以下接口的后端服务（基于 Spring Boot）：

- **用户认证**
  `GET /Users/selectByUsername?username=xxx`
  `POST /Users/insertUser`
- **聊天**
  `GET /Topics/selectByUserId?userId=xxx`
  `POST /Topics/insertTopics`
  `GET /Topics/incrementMessageCount?id=xxx`
  `POST /ChatMessage/insertChatMessages`
  `GET /ChatMessage/selectByTopicId?topicId=xxx`
  `GET /ChatMessage/deleteByTopicId?topicId=xxx`
  `GET /Topics/deleteByUserId?userId=xxx`
- **邮箱验证**
  `POST /api/v1/email/send-code`
  `POST /api/v1/email/verify-code`
- **用户资料与头像**
  `POST /UserProfiles/insertUserProfiles`
  `GET /UserProfiles/selectById?userId=xxx`
  `POST /UserProfiles/upload`（multipart/form-data）
  `GET /UserProfiles/addHeadImage?userId=xxx&avatarUrl=xxx`
  `GET /UserProfiles/download?name=xxx`

后端基础地址在 `ApiConfig.cs` 中配置（默认值：`http://your-server-ip-or-domain:port`），请替换为你自己的服务器地址。

## 🚀 快速开始

### 环境要求

- [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0) 或更高版本
- Visual Studio 2022（17.8+）或安装了 MAUI 工作负载的 VS Code
- 对应目标平台的 Android / iOS / macOS / Windows 开发环境

### 克隆仓库

```bash
git clone https://github.com/Nathan-code-development/AIApplication.git
cd AITools
```

### 配置 API Key（重要）

`Services/AiApiService.cs` 中包含用于演示的硬编码 API Key。**请勿将真实密钥提交到 GitHub。** 请替换为你自己的密钥，或改用更安全的配置方案。

```csharp
private const string DeepSeekApiKey = "your-deepseek-key";
private const string DoubaoApiKey = "your-doubao-key";
private const string QianwenApiKey = "your-qianwen-key";
```

也可以将密钥迁移到 `appsettings.json`，并通过配置构建器读取。

### 修改后端地址

编辑 `Services/ApiConfig.cs`：

```csharp
public const string BaseUrl = "http://your-server-address:port";
```

### 编译与运行

- 使用 Visual Studio 打开解决方案
- 选择运行目标（如 Android 模拟器、Windows 计算机）
- 按 **F5** 开始调试

## 📁 项目结构

```text
AITools/
├── Models/
│   └── AIModel.cs                 # 模型广场的数据模型
├── Services/
│   ├── AiApiService.cs            # AI 接口调用（DeepSeek、豆包、通义千问）
│   ├── ApiConfig.cs               # 后端地址与 JSON 配置项
│   ├── AuthService.cs             # 登录 / 注册
│   ├── ChatApiService.cs          # 话题与消息的增删改查
│   ├── EmailCodeService.cs        # 邮箱验证码
│   └── UserProfileService.cs      # 个人资料与头像管理
├── Views/
│   ├── AI.xaml/.cs                # 聊天主页面
│   ├── AllTopicsPage.xaml/.cs     # 全部会话话题列表
│   ├── CompleteProfilePage.xaml/.cs
│   ├── LoginPage.xaml/.cs
│   ├── ModelDetailPage.xaml/.cs   # 模型详情页
│   ├── modelSquare.xaml/.cs       # 模型广场
│   ├── Myself.xaml/.cs            # 个人中心与设置
│   └── RegisterPage.xaml/.cs
├── App.xaml/.cs
├── AppShell.xaml/.cs
└── Resources/                     # 图片、样式、字体
```

## 🔒 安全提示

- 当前 **API Key 为硬编码**，仅适用于个人本地测试。
- 生产环境请将密钥迁移到安全的后端代理，或使用 Azure Key Vault / 环境变量。
- 当前演示后端以明文比对密码。真实项目中请务必对密码进行哈希处理。

## 📄 开源协议

本项目基于 MIT 协议开源，详见 [LICENSE](LICENSE) 文件。

## 🙏 致谢

- [DeepSeek API](https://platform.deepseek.com/)
- [豆包（字节跳动）](https://www.volcengine.com/product/doubao)
- [通义千问（阿里云）](https://dashscope.aliyun.com/)
- [.NET MAUI 社区](https://github.com/dotnet/maui)
