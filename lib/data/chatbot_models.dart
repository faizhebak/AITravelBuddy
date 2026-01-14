// ============================================================================
// DATA MODELS (moved to lib/data)
// ============================================================================

enum MessageType { text, image, imageRecognition, routeCard }

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final MessageType type;
  final bool hasRouteCard;
  final String? imageUrl;
  final ImageRecognitionData? recognitionData;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.type = MessageType.text,
    this.hasRouteCard = false,
    this.imageUrl,
    this.recognitionData,
  });
}

class ChatSession {
  String id;
  String title;
  DateTime createdAt;
  DateTime lastActiveAt;
  List<ChatMessage> messages;
  AISettings aiSettings;
  bool isPinned;

  ChatSession({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.lastActiveAt,
    required this.messages,
    required this.aiSettings,
    this.isPinned = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'lastActiveAt': lastActiveAt.toIso8601String(),
      'messages': messages
          .map(
            (m) => {
              'text': m.text,
              'isUser': m.isUser,
              'timestamp': m.timestamp.toIso8601String(),
              'type': m.type.toString(),
              'hasRouteCard': m.hasRouteCard,
              'imageUrl': m.imageUrl,
            },
          )
          .toList(),
      'aiSettings': aiSettings.toJson(),
      'isPinned': isPinned,
    };
  }

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'],
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
      lastActiveAt: DateTime.parse(json['lastActiveAt']),
      messages: (json['messages'] as List)
          .map(
            (m) => ChatMessage(
              text: m['text'],
              isUser: m['isUser'],
              timestamp: DateTime.parse(m['timestamp']),
              type: MessageType.values.firstWhere(
                (e) => e.toString() == m['type'],
              ),
              hasRouteCard: m['hasRouteCard'] ?? false,
              imageUrl: m['imageUrl'],
            ),
          )
          .toList(),
      aiSettings: AISettings.fromJson(json['aiSettings']),
      isPinned: json['isPinned'] ?? false,
    );
  }
}

class AISettings {
  int humorLevel;
  String answerLength;
  String professionalism;
  String avatarOutfit;
  String regionalFocus;
  List<String> specialInterests;
  String language;

  AISettings({
    required this.humorLevel,
    required this.answerLength,
    required this.professionalism,
    required this.avatarOutfit,
    this.regionalFocus = 'All Malaysia',
    this.specialInterests = const [],
    this.language = 'en',
  });

  static AISettings defaultSettings() {
    return AISettings(
      humorLevel: 2,
      answerLength: 'medium',
      professionalism: 'friendly',
      avatarOutfit: 'traditional',
      regionalFocus: 'All Malaysia',
      specialInterests: ['food', 'culture'],
      language: 'en',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'humorLevel': humorLevel,
      'answerLength': answerLength,
      'professionalism': professionalism,
      'avatarOutfit': avatarOutfit,
      'regionalFocus': regionalFocus,
      'specialInterests': specialInterests,
      'language': language,
    };
  }

  factory AISettings.fromJson(Map<String, dynamic> json) {
    return AISettings(
      humorLevel: json['humorLevel'],
      answerLength: json['answerLength'],
      professionalism: json['professionalism'],
      avatarOutfit: json['avatarOutfit'],
      regionalFocus: json['regionalFocus'] ?? 'All Malaysia',
      specialInterests: List<String>.from(json['specialInterests'] ?? []),
      language: json['language'] ?? 'en',
    );
  }

  AISettings copyWith({
    int? humorLevel,
    String? answerLength,
    String? professionalism,
    String? avatarOutfit,
    String? regionalFocus,
    List<String>? specialInterests,
    String? language,
  }) {
    return AISettings(
      humorLevel: humorLevel ?? this.humorLevel,
      answerLength: answerLength ?? this.answerLength,
      professionalism: professionalism ?? this.professionalism,
      avatarOutfit: avatarOutfit ?? this.avatarOutfit,
      regionalFocus: regionalFocus ?? this.regionalFocus,
      specialInterests: specialInterests ?? this.specialInterests,
      language: language ?? this.language,
    );
  }

  /// Converts to API user_preference format
  Map<String, dynamic> toApiPreference() {
    return {
      'Professionalism': professionalism,
      'HumorLevel': _humorLevelToString(humorLevel),
    };
  }

  String _humorLevelToString(int level) {
    switch (level) {
      case 1:
        return 'none';
      case 2:
        return 'low';
      case 3:
        return 'moderate';
      case 4:
        return 'high';
      default:
        return 'moderate';
    }
  }

  String generateSystemPrompt() {
    String prompt = '''
You are the Malaysia Explorer AI Assistant—a knowledgeable, culturally 
sensitive guide to Malaysian tourism. Your mission is to help travelers 
discover, plan, and enjoy their Malaysian adventures.
''';

    switch (humorLevel) {
      case 1:
        prompt +=
            '\nUse formal, professional language. No jokes or emojis except when absolutely necessary.';
        break;
      case 2:
        prompt +=
            '\nBe conversational and friendly. Use occasional emojis to maintain engagement.';
        break;
      case 3:
        prompt +=
            '\nAdd light humor and playful language. Use emojis liberally to create a fun atmosphere.';
        break;
      case 4:
        prompt +=
            '\nBe enthusiastic and fun! Use lots of emojis, casual slang, and pop culture references.';
        break;
    }

    switch (answerLength) {
      case 'short':
        prompt +=
            '\nKeep responses concise (1-2 sentences max). Get straight to the point.';
        break;
      case 'medium':
        prompt +=
            '\nProvide balanced paragraphs (3-5 sentences). Cover key points without overwhelming.';
        break;
      case 'detailed':
        prompt +=
            '\nGive comprehensive, detailed explanations with historical context, cultural insights, and practical tips.';
        break;
    }

    switch (professionalism) {
      case 'casual':
        prompt +=
            '\nSound like a friendly traveler sharing tips. Use "you" and "I". Be relatable and down-to-earth.';
        break;
      case 'friendly':
        prompt +=
            '\nBe a warm, knowledgeable tour guide. Engaging but professional. Balance facts with storytelling.';
        break;
      case 'professional':
        prompt +=
            '\nBe a formal tourism expert. Use precise language, cite sources when relevant, and maintain authority.';
        break;
    }

    if (regionalFocus != 'All Malaysia') {
      prompt +=
          '\nPrioritize information about $regionalFocus when answering questions.';
    }

    if (specialInterests.isNotEmpty) {
      prompt +=
          '\nThe user is particularly interested in: ${specialInterests.join(", ")}. Emphasize these aspects when relevant.';
    }

    prompt += '''

CORE RESPONSIBILITIES:
- Provide accurate information about Malaysian attractions, food, culture, and travel logistics
- Be culturally sensitive to Malaysia's multicultural society
- Correct misconceptions respectfully
- Never provide medical diagnoses, political commentary, or financial advice

Always prioritize helpful, accurate, and culturally appropriate responses.
''';

    return prompt;
  }
}

class ImageRecognitionData {
  final String name;
  final double confidence;
  final String description;
  final String culturalContext;
  final List<String> ingredients;
  final List<Recommendation>? recommendations;
  final String? funFact;

  ImageRecognitionData({
    required this.name,
    required this.confidence,
    required this.description,
    required this.culturalContext,
    required this.ingredients,
    this.recommendations,
    this.funFact,
  });
}

class Recommendation {
  final String name;
  final String location;
  final double rating;
  final String priceRange;

  Recommendation({
    required this.name,
    required this.location,
    required this.rating,
    required this.priceRange,
  });
}

class RouteStop {
  final String number;
  final String title;
  final String description;
  final String duration;

  RouteStop({
    required this.number,
    required this.title,
    required this.description,
    required this.duration,
  });
}

final List<RouteStop> sampleRoute = [
  RouteStop(
    number: '1',
    title: 'A Famosa Fort',
    description: 'Portuguese fortress from 1511',
    duration: '30 min',
  ),
  RouteStop(
    number: '2',
    title: 'St. Paul\'s Hill',
    description: 'Historic church ruins with city views',
    duration: '45 min',
  ),
  RouteStop(
    number: '3',
    title: 'Jonker Street',
    description: 'Night market & antique shops',
    duration: '1.5 hrs',
  ),
  RouteStop(
    number: '4',
    title: 'Cheng Hoon Teng Temple',
    description: 'Oldest Chinese temple in Malaysia',
    duration: '30 min',
  ),
  RouteStop(
    number: '5',
    title: 'Melaka River Cruise',
    description: 'Scenic river tour',
    duration: '1 hr',
  ),
];
