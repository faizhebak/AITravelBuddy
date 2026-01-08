import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final http.Client _client = http.Client();

  Future<void> sendMessage({
    required String sessionId,
    required String userId,
    required String message,
    String? imageBase64,
    Map<String, String>? userPreference,
    Map<String, String>? context,
    required Function(String chunk) onChunk,
    required Function(ChatResponse response) onDone,
    required Function(String error) onError,
  }) async {
    try {
      final request = http.Request('POST', Uri.parse('http://10.0.2.2:8000/api/chat'));
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'text/event-stream';

      final body = <String, dynamic>{
        'session_id': sessionId,
        'user_id': userId,
        'user_message': message,
      };
      if (imageBase64 != null) body['image_base64'] = imageBase64;
      if (userPreference != null) body['user_preference'] = userPreference;
      if (context != null) body['context'] = context;

      request.body = jsonEncode(body);
      final response = await _client.send(request);

      if (response.statusCode != 200) {
        onError('Server returned status ${response.statusCode}');
        return;
      }

      String currentEvent = 'message';
      await for (final chunk in response.stream.transform(utf8.decoder)) {
        for (final line in chunk.split('\n')) {
          final trimmed = line.trim();
          if (trimmed.isEmpty) continue;

          if (trimmed.startsWith('event:')) {
            currentEvent = trimmed.substring(6).trim();
          } else if (trimmed.startsWith('data:')) {
            final data = jsonDecode(trimmed.substring(5).trim());
            switch (currentEvent) {
              case 'message': onChunk(data['chunk'] ?? ''); break;
              case 'done': onDone(ChatResponse.fromJson(data)); break;
              case 'error': onError(data['error'] ?? 'Unknown error'); break;
            }
          }
        }
      }
    } catch (e) {
      onError('Connection error: $e');
    }
  }

  void dispose() => _client.close();
}

class ChatResponse {
  final String sessionTitle;
  final String response;
  final List<String> agentsUsed;

  ChatResponse({required this.sessionTitle, required this.response, required this.agentsUsed});

  factory ChatResponse.fromJson(Map<String, dynamic> json) => ChatResponse(
    sessionTitle: json['session_title'] ?? '',
    response: json['response'] ?? '',
    agentsUsed: List<String>.from(json['agents_used'] ?? []),
  );
}