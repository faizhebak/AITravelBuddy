# 🚀 Features

## AI Chat with SSE Streaming
- **Real-time Interaction**: Fully integrated with the backend (`/api/chat`) to support fluid conversations.
- **Streaming Responses**: Uses Server-Sent Events (SSE) to display text chunks as they arrive, reducing perceived latency.

## Customizable AI Persona
- **Personalized Experience**: Users can adjust the AI's "Professionalism" (Casual, Friendly, Professional) and "Humor Level".
- **State Persistence**: Settings are saved locally via `shared_preferences` and injected into every API request context.

## Image Recognition (Demonstration)
- **Current Status**: **Simulated (Mock Mode)**
- **Functionality**: The UI supports selecting images from the gallery or camera.
- **Implementation**: The logic currently simulates a successful response. The API service (`sendImageMessage`) is implemented but commented out/bypassed in the UI (`route_suggestion.dart`) in favor of a mock response for demonstration purposes.

## AR Scanner (Demonstration)
- **Current Status**: **Simulated (Mock Mode)**
- **Functionality**: Opens the camera and overlays "scanning" UI elements.
- **Implementation**: The app simulates landmark detection after a delay, returning random mock landmarks (e.g., "Petronas Twin Towers", "Batu Caves"). Real ML Kit integration is pending.

## Route Suggestions
- **Interactive Cards**: The chat interface can render special widgets for route suggestions based on backend responses.

## Persistent Settings
User id and preferences are managed via:
- `SettingsService`: Handles local storage.
- `SessionApiService`: Syncs session metadata with the backend.
