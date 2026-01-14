# AI Travel Buddy - Flutter Frontend

AI Travel Buddy is a smart, interactive travel assistant built with Flutter. It provides personalized travel advice, route suggestions, and cultural insights for exploring Malaysia, powered by an AI backend with real-time streaming responses.

## 🚀 Features

- **AI Chat with SSE Streaming**: Real-time conversation with AI travel expert using Server-Sent Events
- **Customizable AI Persona**: Adjust professionalism level and humor via persistent settings
- **Image Recognition**: Capture or select photos for AI analysis (landmarks, food, etc.)
- **Route Suggestions**: Interactive route cards for trip planning
- **AR Scanner**: Scan landmarks for augmented reality information

## 🛠️ Tech Stack

| Component | Technology |
|-----------|------------|
| Framework | Flutter (Dart) |
| Networking | `http` package (SSE streaming) |
| Local Storage | `shared_preferences` |
| Media | `image_picker`, `camera` |
| ML | `google_mlkit_image_labeling` |

## 📂 Project Structure

```
lib/
├── main.dart                    # App entry point
├── data/
│   └── chatbot_models.dart      # Data models (AISettings, ChatMessage, etc.)
├── presentation/
│   ├── route_suggestion.dart    # Main chat interface
│   ├── ai_settings_screen.dart  # Settings customization
│   ├── home.dart                # Home screen
│   ├── ar_scanner_page.dart     # AR scanner
│   └── ...
├── services/
│   ├── chat_api_service.dart    # API client for SSE streaming
│   └── settings_service.dart    # Settings persistence
└── utils/
```

## ⚙️ Setup

### Prerequisites
- Flutter SDK 3.8.1+
- Android Studio / Xcode
- Running backend server

### Installation

```bash
git clone https://github.com/yourrepo/aitravelbuddy.git
cd aitravelbuddy
flutter pub get
flutter run
```

### Backend Configuration

Edit `lib/services/chat_api_service.dart`:

```dart
// For Android Emulator:
static const String baseUrl = 'http://10.0.2.2:8000';

// For Physical Device (replace with your IP):
// static const String baseUrl = 'http://192.168.1.100:8000';
```

## 🔌 API Contract

### POST `/api/chat`

Stream a conversation with the AI using SSE.

**Headers:**
```
Content-Type: application/json
Accept: text/event-stream
```

**Request Body:**
```json
{
  "session_id": "uuid-string",
  "user_id": "user-123",
  "user_message": "What are the best beaches?",
  "image_base64": "optional-base64-jpeg",
  "user_preference": {
    "Professionalism": "casual",
    "HumorLevel": "moderate"
  },
  "context": {
    "current_location": "Mersing"
  }
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| session_id | string | ✅ | Conversation session ID |
| user_id | string | ✅ | User identifier |
| user_message | string | ✅ | User's message |
| image_base64 | string | ❌ | Base64 JPEG for image analysis |
| user_preference | object | ❌ | Professionalism + HumorLevel |
| context | object | ❌ | Location context |

**SSE Response Events:**
```
event: message
data: {"chunk": "Hello! Mersing is..."}

event: done
data: {"session_title": "...", "response": "...", "agents_used": [...]}

event: error
data: {"error": "Error message"}
```

## 💾 Persistent Settings

User preferences are stored locally using `shared_preferences`:

```dart
// Save settings
await SettingsService.saveSettings(userId, aiSettings);

// Load settings
final settings = await SettingsService.loadSettings(userId);
```

Settings are automatically converted to API format via `toApiPreference()`:
- `professionalism` → `Professionalism` (casual/friendly/professional)
- `humorLevel` (1-4) → `HumorLevel` (none/low/moderate/high)

## 📱 Key Screens

| Screen | Description |
|--------|-------------|
| Home | Main dashboard with quick actions |
| Route Suggestion | AI chat interface |
| AI Settings | Customize AI persona |
| AR Scanner | Landmark scanning |

## 🔧 Dependencies

```yaml
dependencies:
  flutter: sdk
  http: ^1.1.0
  shared_preferences: ^2.2.2
  image_picker: ^1.0.4
  camera: ^0.11.3
  uuid: ^4.2.1
  url_launcher: ^6.2.5
  google_mlkit_image_labeling: ^0.14.1
```
