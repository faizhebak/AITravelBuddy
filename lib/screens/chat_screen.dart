import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../services/chat_service.dart';
import '../utils/image_utils.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}



class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  final String _sessionId = const Uuid().v4();
  final String _userId = 'user-123'; // Replace with actual user ID from auth
  
  final List<ChatMessage> _messages = [];
  String _currentResponse = '';
  bool _isLoading = false;
  String? _pendingImageBase64;

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: message, isUser: true));
      _messageController.clear();
      _isLoading = true;
      _currentResponse = '';
    });

    await _chatService.sendMessage(
      sessionId: _sessionId,
      userId: _userId,
      message: message,
      imageBase64: _pendingImageBase64,
      onChunk: (chunk) => setState(() => _currentResponse += chunk),
      onDone: (response) => setState(() {
        _messages.add(ChatMessage(text: response.response, isUser: false));
        _currentResponse = '';
        _isLoading = false;
        _pendingImageBase64 = null;
      }),
      onError: (error) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Travel Buddy')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length + (_currentResponse.isNotEmpty ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _messages.length) {
                  return MessageBubble(message: _messages[index]);
                }
                return MessageBubble(message: ChatMessage(text: _currentResponse, isUser: false));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image, color: _pendingImageBase64 != null ? Colors.green : null),
                  onPressed: () async {
                    final img = await ImageUtils.pickImageAsBase64();
                    if (img != null) setState(() => _pendingImageBase64 = img);
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(hintText: 'Ask about Mersing...'),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: _isLoading ? const CircularProgressIndicator() : const Icon(Icons.send),
                  onPressed: _isLoading ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _chatService.dispose();
    _messageController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(message.text, style: TextStyle(color: message.isUser ? Colors.white : Colors.black)),
      ),
    );
  }
}