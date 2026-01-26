import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service for managing chat sessions via the Laravel backend API.
/// Handles CRUD operations for sessions and message retrieval.
class SessionApiService {
  // Use same base URL as ChatApiService
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';

  /// Fetch all sessions for a user
  /// GET /api/sessions?user_id={id}
  static Future<List<ApiChatSession>> getSessions(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/sessions?user_id=$userId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final List<dynamic> sessionsJson = data['data'];
          return sessionsJson
              .map((json) => ApiChatSession.fromJson(json))
              .toList();
        }
      }
      throw Exception('Failed to load sessions: ${response.statusCode}');
    } catch (e) {
      print('Error fetching sessions: $e');
      rethrow;
    }
  }

  /// Create a new chat session
  /// POST /api/sessions
  static Future<ApiChatSession> createSession({
    required int userId,
    String? title,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/sessions'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          if (title != null) 'title': title,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return ApiChatSession.fromJson(data['data']);
        }
      }
      throw Exception('Failed to create session: ${response.statusCode}');
    } catch (e) {
      print('Error creating session: $e');
      rethrow;
    }
  }

  /// Delete a session and all its messages
  /// DELETE /api/sessions/{id}
  static Future<bool> deleteSession(int sessionId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/sessions/$sessionId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      throw Exception('Failed to delete session: ${response.statusCode}');
    } catch (e) {
      print('Error deleting session: $e');
      rethrow;
    }
  }

  /// Get all messages for a session
  /// GET /api/sessions/{id}/messages
  static Future<SessionMessagesResponse> getSessionMessages(
    int sessionId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/sessions/$sessionId/messages'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return SessionMessagesResponse.fromJson(data['data']);
        }
      }
      throw Exception('Failed to load messages: ${response.statusCode}');
    } catch (e) {
      print('Error fetching messages: $e');
      rethrow;
    }
  }

  /// Update session (e.g., title)
  /// PATCH /api/sessions/{id}
  static Future<ApiChatSession> updateSession({
    required int sessionId,
    String? title,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/api/sessions/$sessionId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({if (title != null) 'title': title}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return ApiChatSession.fromJson(data['data']);
        }
      }
      throw Exception('Failed to update session: ${response.statusCode}');
    } catch (e) {
      print('Error updating session: $e');
      rethrow;
    }
  }
}

/// Represents a session from the backend API
class ApiChatSession {
  final int id;
  final String uuid;
  final int userId;
  final String? title;
  final DateTime createdAt;
  final DateTime updatedAt;

  ApiChatSession({
    required this.id,
    required this.uuid,
    required this.userId,
    this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ApiChatSession.fromJson(Map<String, dynamic> json) {
    return ApiChatSession(
      id: json['id'],
      uuid: json['uuid'],
      userId: json['user_id'],
      title: json['title'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

/// Represents a message from the backend API (DynamoDB)
class ApiChatMessage {
  final String sessionId;
  final String messageId;
  final String role; // 'user' or 'assistant'
  final String content;
  final String? imageBase64;
  final List<String>? agentsUsed;
  final DateTime createdAt;

  ApiChatMessage({
    required this.sessionId,
    required this.messageId,
    required this.role,
    required this.content,
    this.imageBase64,
    this.agentsUsed,
    required this.createdAt,
  });

  factory ApiChatMessage.fromJson(Map<String, dynamic> json) {
    return ApiChatMessage(
      sessionId: json['session_id'],
      messageId: json['message_id'],
      role: json['role'],
      content: json['content'],
      imageBase64: json['image_base64'],
      agentsUsed:
          json['agents_used'] != null
              ? List<String>.from(json['agents_used'])
              : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  bool get isUser => role == 'user';
}

/// Response from GET /api/sessions/{id}/messages
class SessionMessagesResponse {
  final ApiChatSession session;
  final List<ApiChatMessage> messages;

  SessionMessagesResponse({required this.session, required this.messages});

  factory SessionMessagesResponse.fromJson(Map<String, dynamic> json) {
    return SessionMessagesResponse(
      session: ApiChatSession.fromJson(json['session']),
      messages:
          (json['messages'] as List)
              .map((m) => ApiChatMessage.fromJson(m))
              .toList(),
    );
  }
}
