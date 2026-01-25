# 🔌 Backend Integration Specification

This document defines the **server-side API specifications** that the AI Travel Buddy frontend expects. The backend must implement these endpoints to ensure full functionality.

## Core Endpoints

### 1. Chat with AI (Streaming)
**Endpoint:** `POST /api/chat`
**Description:** Initiates a real-time conversation stream with the AI.

**Request Body:**
```json
{
  "session_id": "uuid-string",
  "user_id": "user-unique-id",
  "user_message": "Hello, suggest a trip to Penang.",
  "user_preference": {
    "Professionalism": "casual",
    "HumorLevel": "moderate"
  },
  "context": {
    "current_location": "Kuala Lumpur"
  }
}
```

**Response (SSE Stream):**
The server must return `Content-Type: text/event-stream`.
- **Event: `message`**: Data contains `{"chunk": "partial text"}`.
- **Event: `done`**: Data contains `{"session_title": "Trip to Penang", "response": "full text..", "agents_used": [...]}`.
- **Event: `error`**: Data contains `{"error": "description"}`.

### 2. Image Analysis (Streaming)
**Endpoint:** `POST /api/chat/image`
**Description:** Sends an image for AI analysis and receives a streaming response.

**Request Body:**
```json
{
  "session_id": "uuid-string",
  "image": "base64-encoded-string",
  "caption": "What is this building?"
}
```

**Response (SSE Stream):**
Same structure as `/api/chat`.

### 3. Health Check
**Endpoint:** `GET /api/health`
**Description:** Used by the frontend to verify connectivity on startup.
**Expected Response:** `200 OK`

## Environment Configuration
The frontend uses `flutter_dotenv` to load the backend URL.
Ensure the `.env` file in the frontend root contains:
```env
BASE_URL=http://your-backend-ip:port
```
