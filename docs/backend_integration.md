# 🔌 Backend API Reference

This document defines the backend API that the AI Travel Buddy frontend connects to.

## Base URL
```
http://localhost:8000/api
```

---

## Chat Streaming API

### POST `/api/chat`

Stream a conversation with the AI using Server-Sent Events (SSE).

**Headers:**
```
Content-Type: application/json
Accept: text/event-stream
```

**Request Body:**
```json
{
  "session_id": "550e8400-e29b-41d4-a716-446655440000",
  "user_id": "user-123",
  "user_message": "What are the best beaches in Mersing?",
  "image_base64": "iVBORw0KGgoAAAANSUhEUgAAAAE...",
  "user_preference": {
    "Professionalism": "casual",
    "HumorLevel": "moderate"
  },
  "context": {
    "current_location": "Mersing",
    "attraction": "Pulau Tioman"
  }
}
```

**Request Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `session_id` | string | ✅ | Unique session identifier |
| `user_id` | string | ✅ | Unique user identifier |
| `user_message` | string | ✅ | User's message |
| `image_base64` | string | ❌ | Base64-encoded JPEG for visual analysis |
| `user_preference` | object | ❌ | Communication preferences |
| `context` | object | ❌ | Contextual info (location, attraction) |

**SSE Response Events:**

| Event | Data | Description |
|-------|------|-------------|
| `message` | `{"chunk": "text"}` | Streaming text chunk |
| `done` | `{"session_title": "...", "response": "...", "agents_used": [...]}` | Complete response |
| `error` | `{"error": "message"}` | Error information |

---

## Session Management API

### GET `/api/sessions`
Get all sessions for a user.

**Query:** `?user_id=1`

**Response:**
```json
{
  "success": true,
  "data": [
    {"id": 1, "uuid": "...", "title": "Beach Recommendations", ...}
  ]
}
```

---

### POST `/api/sessions`
Create a new session.

**Request:**
```json
{"user_id": 1, "title": "Trip Planning"}
```

---

### GET `/api/sessions/{id}/messages`
Get all messages for a session.

---

### POST `/api/sessions/{id}/messages`
Add message to a session.

**Request:**
```json
{
  "role": "user",
  "content": "What about food?",
  "image_base64": null,
  "agents_used": []
}
```

---

### DELETE `/api/sessions/{id}`
Delete a session and its messages.

---

## Health Check

### GET `/api/health`
Check API status.

**Response:**
```json
{"status": "ok", "service": "AI Travel Buddy API"}
```

---

## Environment Configuration
Create `.env` in project root:
```env
BASE_URL=http://localhost:8000
```
