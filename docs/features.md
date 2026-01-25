# 🚀 Features

## AI Chat with SSE Streaming
- **Real-time Interaction**: Fully integrated with `/api/chat` endpoint.
- **Streaming Responses**: Uses Server-Sent Events (SSE) for live text chunks.

## Image Recognition
- **Visual Analysis**: Send images via `/api/chat` endpoint with `image_base64` field.
- **Automatic Prompt**: Uses "Analyze this image and tell me about it." when sending images.

## Customizable AI Persona
- **Personalized Experience**: Adjust "Professionalism" and "Humor Level".
- **State Persistence**: Settings saved locally via `shared_preferences`.

## AR Scanner (Demonstration)
- **Current Status**: Simulated (Mock Mode)
- **Functionality**: Camera feed with mock landmark detection.

## Session Management
- Session create, load, rename, and delete.
- Full message history sync with backend.

## Persistent Settings
Settings are managed via:
- `SettingsService`: Local storage.
- `SessionApiService`: Backend sync.
