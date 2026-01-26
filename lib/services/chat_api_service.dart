import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatApiService {
  // Ensure you have a .env file with BASE_URL defined
  // Example: BASE_URL=http://your-backend-url

  // // For Android Emulator:
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';

  // // For iOS Simulator (if running on Mac):
  // static const String baseUrl = 'http://localhost:8000';

  // // For Physical Device (replace with your computer's IP):
  // static const String baseUrl = 'http://192.168.1.100:8000';

  // // For Production:
  // static const String baseUrl = 'https://your-domain.com';

  /// Sends a message and returns a stream of AI response chunks
  static Stream<String> sendMessage({
    required String sessionId,
    required String userId,
    required String userMessage,
    String? imageBase64,
    Map<String, dynamic>? userPreference,
    Map<String, dynamic>? context,
  }) async* {
    final url = Uri.parse('$baseUrl/api/chat');

    try {
      // Create the request
      final request = http.Request('POST', url);
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'text/event-stream';

      // Set the body with all required and optional fields
      final Map<String, dynamic> body = {
        'session_id': sessionId,
        'user_id': userId,
        'user_message': userMessage,
      };
      if (imageBase64 != null) body['image_base64'] = imageBase64;
      if (userPreference != null) body['user_preference'] = userPreference;
      if (context != null) body['context'] = context;

      request.body = jsonEncode(body);

      // Send the request
      final streamedResponse = await request.send();

      if (streamedResponse.statusCode != 200) {
        throw Exception(
          'Failed to send message: ${streamedResponse.statusCode}',
        );
      }

      // Process the SSE stream
      String buffer = '';

      await for (var chunk in streamedResponse.stream.transform(utf8.decoder)) {
        buffer += chunk;

        // Split by newlines to process complete SSE events
        final lines = buffer.split('\n');
        buffer = lines.last; // Keep incomplete line in buffer

        for (var i = 0; i < lines.length - 1; i++) {
          final line = lines[i].trim();

          if (line.isEmpty) continue;

          // Parse SSE format: "event: message" or "data: {...}"
          if (line.startsWith('event:')) {
            final eventType = line.substring(6).trim();

            if (eventType == 'done') {
              // Stream completed
              return;
            }
          } else if (line.startsWith('data:')) {
            final jsonData = line.substring(5).trim();

            try {
              final data = jsonDecode(jsonData);

              // Yield the chunk if it exists
              if (data['chunk'] != null) {
                yield data['chunk'] as String;
              }

              // Check if this is the final message with full response
              if (data['response'] != null) {
                // You can handle the complete response here if needed
                // For now, we're already streaming chunks, so this is optional
              }
            } catch (e) {
              print('Error parsing JSON: $e');
            }
          }
        }
      }
    } catch (e) {
      print('Error in sendMessage: $e');
      throw Exception('Failed to communicate with server: $e');
    }
  }

  /// Test connection to backend
  static Future<bool> testConnection() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/api/health'))
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }
}

/// Helper class to track streaming state
class StreamingMessage {
  String fullText = '';
  bool isComplete = false;

  void addChunk(String chunk) {
    fullText += chunk;
  }

  void markComplete() {
    isComplete = true;
  }
}
