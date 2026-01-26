# 🏗️ Architecture & Tech Stack

## Technology Stack

| Component | Technology | Description |
|-----------|------------|-------------|
| **Framework** | Flutter (Dart) | Cross-platform UI development |
| **Networking** | `http`, `flutter_dotenv` | API communication and Environment configuration |
| **Local Storage** | `shared_preferences` | Persisting user settings and preferences locally |
| **Camera** | `camera` | Capturing photos for AR and Analysis |


## Project Structure

```
lib/
├── main.dart                    # App entry point
├── data/
│   └── chatbot_models.dart      # Data models
├── presentation/
│   ├── route_suggestion.dart    # Chat Interface (Includes Mocked Image Logic)
│   ├── ar_scanner_page.dart     # AR Scanner (Currently Mocked/Simulated)
│   ├── ...
├── services/
│   ├── chat_api_service.dart    # Real API Service (Streaming, Image Upload)
│   ├── session_api_service.dart # Session management
│   └── settings_service.dart    # Local settings persistence
└── utils/
```

## Feature Architecture

1.  **AI Chat**:
    -   UI (`RouteSuggestion`) -> `ChatApiService` -> **Real Backend** (POST /api/chat).

2.  **AR Scanner**:
    -   UI (`ARScannerPage`) -> **Mock Logic** (Simulated delays & random results).
    -   *Note: Code contains strict separation to easily swap Mock for Real ML Kit implementation.*

3.  **Image Recognition**:
    -   UI -> **Mock Logic** (Simulated response).
    -   *Note: `ChatApiService` has methods for real image upload, but they are currently disconnected in the UI.*
