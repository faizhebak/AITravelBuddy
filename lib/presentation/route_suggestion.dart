import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import '../data/chatbot_models.dart';
import 'ai_settings_screen.dart';
import '../services/settings_service.dart';
import '../services/chat_api_service.dart';
import '../presentation/ar_scanner_page.dart';

class RouteSuggestion extends StatefulWidget {
  const RouteSuggestion({super.key});

  @override
  RouteSuggestionState createState() => RouteSuggestionState();
}

class RouteSuggestionState extends State<RouteSuggestion> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker _picker = ImagePicker();

  List<ChatSession> _allSessions = [];
  ChatSession? _currentSession;
  bool _isTyping = false;
  AISettings _globalSettings = AISettings.defaultSettings();

  @override
  void initState() {
    super.initState();
    _loadChatSessions();
    _createNewSession();
    _loadSettingsFromStore();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadChatSessions() {
    setState(() {
      _allSessions = [
        ChatSession(
          id: 'demo-1',
          title: 'Penang Food Guide',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          lastActiveAt: DateTime.now().subtract(const Duration(hours: 1)),
          messages: [],
          aiSettings: _globalSettings,
        ),
      ];
    });
  }

  void _createNewSession() {
    final newSession = ChatSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New Chat',
      createdAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
      messages: [],
      aiSettings: _globalSettings,
    );

    setState(() {
      _currentSession = newSession;
      _allSessions.insert(0, newSession);
    });

    // Load initial greeting from backend
    _sendInitialGreeting();
  }

  // Update _sendMessage method to use the new backend call:
  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty || _currentSession == null) {
      return;
    }

    final userMessage = _messageController.text.trim();

    setState(() {
      // Add user message
      _currentSession!.messages.add(
        ChatMessage(text: userMessage, isUser: true, timestamp: DateTime.now()),
      );
      _currentSession!.lastActiveAt = DateTime.now();

      // Update title if this is the first message
      if (_currentSession!.messages.length == 2) {
        _currentSession!.title = _generateTitle(userMessage);
      }

      _messageController.clear();
    });

    _scrollToBottom();

    // Send to backend instead of simulating
    _sendMessageToBackend(userMessage);
  }

  String _generateTitle(String message) {
    if (message.toLowerCase().contains('food')) return 'Food Recommendations';
    if (message.toLowerCase().contains('hotel')) return 'Hotel Booking';
    if (message.toLowerCase().contains('route')) return 'Route Planning';
    return message.split(' ').take(3).join(' ');
  }

  // New method to send message to backend with streaming response
  void _sendMessageToBackend(String userMessage) async {
    if (!mounted) return;

    // Show typing indicator
    setState(() {
      _isTyping = true;
    });

    try {
      // Create a temporary message for streaming response
      final streamingMessage = ChatMessage(
        text: '',
        isUser: false,
        timestamp: DateTime.now(),
        hasRouteCard: userMessage.toLowerCase().contains('route'),
      );

      // Add the empty message to the list
      setState(() {
        _currentSession!.messages.add(streamingMessage);
        _isTyping = false;
      });

      // Get the index of this message
      final messageIndex = _currentSession!.messages.length - 1;

      // Stream the response
      await for (final chunk in ChatApiService.sendMessage(
        sessionId: _currentSession!.id,
        userId: await _getUserId(),
        userMessage: userMessage,
        userPreference: _currentSession!.aiSettings.toApiPreference(),
      )) {
        if (!mounted) break;

        setState(() {
          // Update the message text with new chunk
          _currentSession!.messages[messageIndex] = ChatMessage(
            text: _currentSession!.messages[messageIndex].text + chunk,
            isUser: false,
            timestamp: streamingMessage.timestamp,
            hasRouteCard: streamingMessage.hasRouteCard,
          );
        });

        // Auto-scroll as text comes in
        _scrollToBottom();
      }

      // Mark as complete
      if (mounted) {
        setState(() {
          _currentSession!.lastActiveAt = DateTime.now();
        });
      }
    } catch (e) {
      print('Error streaming message: $e');

      if (!mounted) return;

      setState(() {
        _isTyping = false;
        _currentSession!.messages.add(
          ChatMessage(
            text:
                'Sorry, I encountered an error. Please check your connection and try again.',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });

      // Show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Add a method to send initial greeting
  void _sendInitialGreeting() async {
    if (_currentSession == null || _currentSession!.messages.length > 1) {
      return;
    }

    setState(() {
      _isTyping = true;
    });

    try {
      // Create streaming message for welcome
      final streamingMessage = ChatMessage(
        text: '',
        isUser: false,
        timestamp: DateTime.now(),
      );

      setState(() {
        // Replace the hardcoded welcome message
        _currentSession!.messages.clear();
        _currentSession!.messages.add(streamingMessage);
        _isTyping = false;
      });

      final messageIndex = 0;

      // Stream the initial greeting
      await for (final chunk in ChatApiService.sendMessage(
        sessionId: _currentSession!.id,
        userId: await _getUserId(),
        userMessage: 'Hello!', // Trigger backend greeting
        userPreference: _currentSession!.aiSettings.toApiPreference(),
      )) {
        if (!mounted) break;

        setState(() {
          _currentSession!.messages[messageIndex] = ChatMessage(
            text: _currentSession!.messages[messageIndex].text + chunk,
            isUser: false,
            timestamp: streamingMessage.timestamp,
          );
        });

        _scrollToBottom();
      }
    } catch (e) {
      print('Error loading initial greeting: $e');

      // Fallback to hardcoded message
      if (mounted) {
        setState(() {
          _isTyping = false;
          _currentSession!.messages.clear();
          _currentSession!.messages.add(
            ChatMessage(
              text:
                  "Selamat datang! 👋 I'm your Malaysia tourism AI assistant. I can help you with:\n\n🏨 Hotel Booking\n🗺️ Route Suggestions\n🍜 Food Recommendations\n📸 Food Recognition\n🎭 Cultural Insights\n\nWhat would you like to explore today?",
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
        });
      }
    }
  }

// Method to scroll to bottom of chat
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Method to handle image upload
  void _handleImageUpload() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Upload Image',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: const Text(
                'Take Photo',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                Navigator.pop(context);
                await _takePhoto();
              },
            ),

            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: const Text(
                'Choose from Gallery',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                Navigator.pop(context);
                await _chooseFromGallery();
              },
            ),

            ListTile(
              leading: const Icon(Icons.close, color: Colors.white),
              title: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  // Method to take photo using camera
  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85, // Compress image
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (photo != null) {
        final File imageFile = File(photo.path);

        // Add image to chat as user message
        setState(() {
          _currentSession!.messages.add(
            ChatMessage(
              text: '[Image captured]',
              isUser: true,
              timestamp: DateTime.now(),
              type: MessageType.image,
              imageUrl: photo.path, // Local file path
            ),
          );
          _currentSession!.lastActiveAt = DateTime.now();
        });

        _scrollToBottom();

        // TODO: Send image to backend for recognition
        _sendImageToBackend(imageFile);
      }
    } catch (e) {
      print('Error taking photo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to take photo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Method to choose image from gallery
  Future<void> _chooseFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        final File imageFile = File(image.path);

        // Add image to chat as user message
        setState(() {
          _currentSession!.messages.add(
            ChatMessage(
              text: '[Image selected]',
              isUser: true,
              timestamp: DateTime.now(),
              type: MessageType.image,
              imageUrl: image.path,
            ),
          );
          _currentSession!.lastActiveAt = DateTime.now();
        });

        _scrollToBottom();

        // TODO: Send image to backend for recognition
        _sendImageToBackend(imageFile);
      }
    } catch (e) {
      print('Error selecting image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to select image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Method to send image to backend
  Future<void> _sendImageToBackend(File imageFile) async {
    if (!mounted) return;

    setState(() {
      _isTyping = true;
    });

    try {
      // Create streaming message for AI response
      final streamingMessage = ChatMessage(
        text: '',
        isUser: false,
        timestamp: DateTime.now(),
      );

      setState(() {
        _currentSession!.messages.add(streamingMessage);
        _isTyping = false;
      });

      final messageIndex = _currentSession!.messages.length - 1;

      // TODO: Replace with actual image recognition API call
      // Stream the initial greeting
      await for (final chunk in ChatApiService.sendMessage(
        sessionId: _currentSession!.id,
        userId: await _getUserId(),
        userMessage: 'Hello!', // Trigger backend greeting
        userPreference: _currentSession!.aiSettings.toApiPreference(),
      )) {
        if (!mounted) break;

        setState(() {
          _currentSession!.messages[messageIndex] = ChatMessage(
            text: _currentSession!.messages[messageIndex].text + chunk,
            isUser: false,
            timestamp: streamingMessage.timestamp,
          );
        });

        _scrollToBottom();
      }
      // For now, simulate a response
      await Future.delayed(const Duration(seconds: 2));

      // setState(() {
      //   _currentSession!.messages[messageIndex] = ChatMessage(
      //     text:
      //         '🖼️ Image Analysis:\n\nI can see this is an image! In the production version, I would analyze this image and provide information about Malaysian landmarks, food, or cultural items shown.\n\nWould you like to know more about what\'s in this image?',
      //     isUser: false,
      //     timestamp: streamingMessage.timestamp,
      //   );
      // });

      /* PRODUCTION CODE - Uncomment when backend is ready:
      
      // Convert image to base64 or multipart
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      // Stream the image recognition response
      await for (final chunk in ChatApiService.sendImageMessage(
        sessionId: _currentSession!.id,
        imageBase64: base64Image,
      )) {
        if (!mounted) break;

        setState(() {
          _currentSession!.messages[messageIndex] = ChatMessage(
            text: _currentSession!.messages[messageIndex].text + chunk,
            isUser: false,
            timestamp: streamingMessage.timestamp,
          );
        });

        _scrollToBottom();
      }
      */

      _scrollToBottom();
    } catch (e) {
      print('Error sending image: $e');

      if (!mounted) return;

      setState(() {
        _isTyping = false;
        _currentSession!.messages.add(
          ChatMessage(
            text: 'Sorry, I couldn\'t analyze the image. Please try again.',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image analysis failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF000000),
      drawer: _buildSidebarDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _currentSession == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 16,
                      ),
                      itemCount:
                          _currentSession!.messages.length +
                          (_isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (_isTyping &&
                            index == _currentSession!.messages.length) {
                          return _buildTypingIndicator();
                        }
                        return _buildMessageBubble(
                          _currentSession!.messages[index],
                        );
                      },
                    ),
            ),
            _buildInputArea(),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF121212),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFF2A2A2A))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Chat History',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                          _createNewSession();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _allSessions.length,
                itemBuilder: (context, index) {
                  final session = _allSessions[index];
                  final isActive = _currentSession?.id == session.id;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _currentSession = session;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: isActive
                            ? const LinearGradient(
                                colors: [Color(0xFFA51212), Color(0xFFD32F2F)],
                              )
                            : null,
                        color: isActive ? null : const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        session.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAISettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AISettingsScreen(
          settings: _globalSettings,
          onSave: (newSettings) async {
            final userId = await _getUserId();
            await SettingsService.saveSettings(userId, newSettings);
            setState(() {
              _globalSettings = newSettings;
              if (_currentSession != null) {
                _currentSession!.aiSettings = newSettings;
              }
            });
          },
        ),
      ),
    );
  }

  // Placeholder user id retrieval - replace with real phone/user id retrieval as needed
  Future<String> _getUserId() async {
    return 'local_user';
  }

  Future<void> _loadSettingsFromStore() async {
    final userId = await _getUserId();
    final settings = await SettingsService.loadSettings(userId);
    setState(() {
      _globalSettings = settings;
      if (_currentSession != null) {
        _currentSession!.aiSettings = settings;
      }
    });
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0x4DA51212),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: const LinearGradient(
          colors: [Color(0xFFA51212), Color(0xFFD32F2F), Color(0xFF8B0000)],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          Expanded(
            child: Column(
              children: const [
                Text(
                  "Malaysia Explorer",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Discover Malaysia with AR & AI",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: _openAISettings,
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient: const LinearGradient(
                colors: [Color(0xFFA51212), Color(0xFFD32F2F)],
              ),
            ),
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(right: 9),
            child: const Text("👔", style: TextStyle(fontSize: 18)),
          ),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF2A2A2A)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text("●", style: TextStyle(color: Color(0xFFB3B3B3))),
                SizedBox(width: 4),
                Text("●", style: TextStyle(color: Color(0xFFB3B3B3))),
                SizedBox(width: 4),
                Text("●", style: TextStyle(color: Color(0xFFB3B3B3))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                gradient: const LinearGradient(
                  colors: [Color(0xFFA51212), Color(0xFFD32F2F)],
                ),
              ),
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(right: 9),
              child: const Text("👔", style: TextStyle(fontSize: 18)),
            ),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // Show image if message has one
                if (message.type == MessageType.image &&
                    message.imageUrl != null) ...[
                  Container(
                    margin: EdgeInsets.only(
                      right: message.isUser ? 0 : 32,
                      left: message.isUser ? 32 : 0,
                      bottom: 8,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        File(message.imageUrl!),
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],

                // Text bubble
                if (message.text.isNotEmpty) ...[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: message.isUser
                            ? const Color(0xFFA51212)
                            : const Color(0xFF2A2A2A),
                      ),
                      borderRadius: BorderRadius.circular(16),
                      gradient: message.isUser
                          ? const LinearGradient(
                              colors: [Color(0xFFA51212), Color(0xFFD32F2F)],
                            )
                          : null,
                      color: message.isUser ? null : const Color(0xFF1E1E1E),
                    ),
                    padding: const EdgeInsets.all(13),
                    margin: EdgeInsets.only(
                      right: message.isUser ? 0 : 32,
                      left: message.isUser ? 32 : 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatTime(message.timestamp),
                          style: TextStyle(
                            color: message.isUser
                                ? const Color(0xFFFFFEFE)
                                : const Color(0xFFB3B3B3),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (message.hasRouteCard) ...[
                  const SizedBox(height: 8),
                  _buildRouteCard(),
                ],
              ],
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 31,
              height: 31,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: const Color(0xFF2A2A2A),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/kZ2ICKDiv2/5b0u8lbp_expires_30_days.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRouteCard() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF2A2A2A)),
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF1E1E1E),
      ),
      padding: const EdgeInsets.all(17),
      margin: const EdgeInsets.only(right: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRouteStop(
            "1",
            "A Famosa Fort",
            "Portuguese fortress from 1511",
            "30 min",
            true,
          ),
          _buildRouteStop(
            "2",
            "St. Paul's Hill",
            "Historic church ruins",
            "45 min",
            true,
          ),
          _buildRouteStop(
            "3",
            "Jonker Street",
            "Night market & shops",
            "1.5 hrs",
            true,
          ),
          _buildRouteStop(
            "4",
            "Cheng Hoon Teng Temple",
            "Oldest Chinese temple",
            "30 min",
            true,
          ),
          _buildRouteStop(
            "5",
            "Melaka River Cruise",
            "Scenic river tour",
            "1 hr",
            false,
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () => print('Open Google Maps'),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [Color(0xFFA51212), Color(0xFFD32F2F)],
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: const Center(
                child: Text(
                  "Open in Google Maps",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteStop(
    String number,
    String title,
    String description,
    String duration,
    bool hasLine,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFA51212), Color(0xFFD32F2F)],
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (hasLine)
                Container(
                  width: 2,
                  height: 40,
                  margin: const EdgeInsets.only(top: 5),
                  color: const Color(0xFF2A2A2A),
                ),
            ],
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFFB3B3B3),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF2A2A2A),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  child: Text(
                    duration,
                    style: const TextStyle(
                      color: Color(0xFFB3B3B3),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      color: const Color(0xFF121212),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          InkWell(
            onTap: _handleImageUpload,
            child: Container(
              width: 35,
              height: 35,
              margin: const EdgeInsets.only(right: 8),
              child: const Icon(Icons.camera_alt, color: Colors.white),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: "Ask me anything about Malaysia...",
                hintStyle: const TextStyle(
                  color: Color(0xFFB3B3B3),
                  fontSize: 16,
                ),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFA51212)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 9),
          InkWell(
            onTap: _sendMessage,
            child: Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [Color(0xFFA51212), Color(0xFFD32F2F)],
                ),
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF121212)),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/kZ2ICKDiv2/rcl0gtkr_expires_30_days.png",
            "Home",
            false,
            () => Navigator.pop(context),
          ),
          _buildNavItem(
            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/kZ2ICKDiv2/k9kjfm62_expires_30_days.png",
            "AR Scan",
            false,
            () => _navigateToPage(context, const ARScannerPage()),
          ),
          _buildNavItem(
            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/kZ2ICKDiv2/nyaet7u9_expires_30_days.png",
            "Chat AI",
            true,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    String icon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: isActive
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x4DA51212),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
                gradient: const LinearGradient(
                  colors: [Color(0xFFA51212), Color(0xFFD32F2F)],
                ),
              )
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 11),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(icon, width: 23, height: 23),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFFB3B3B3),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";
  }
}
