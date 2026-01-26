import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/chatbot_models.dart';

class SettingsService {
  static String _keyFor(String userId) => 'ai_settings_$userId';

  static Future<void> saveSettings(String userId, AISettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(settings.toJson());
    await prefs.setString(_keyFor(userId), jsonStr);
  }

  static Future<AISettings> loadSettings(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyFor(userId));
    if (jsonStr == null) return AISettings.defaultSettings();
    try {
      final Map<String, dynamic> map = jsonDecode(jsonStr);
      return AISettings.fromJson(map);
    } catch (e) {
      await prefs.remove(_keyFor(userId));
      return AISettings.defaultSettings();
    }
  }

  static Future<void> removeSettings(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyFor(userId));
  }
}
