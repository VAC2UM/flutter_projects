import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/models/user.dart';

class PreferencesHelper {
  static const String _keyDarkMode = 'dark_mode';
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyCurrentUser = 'current_user';
  static const String _keyUserProfile = 'user_profile';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('PreferencesHelper not initialized. Call init() first.');
    }
    return _prefs!;
  }

  static Future<bool> getDarkMode() async {
    return prefs.getBool(_keyDarkMode) ?? false;
  }

  static Future<void> setDarkMode(bool isDarkMode) async {
    await prefs.setBool(_keyDarkMode, isDarkMode);
  }

  static Future<bool> getNotificationsEnabled() async {
    return prefs.getBool(_keyNotificationsEnabled) ?? true;
  }

  static Future<void> setNotificationsEnabled(bool enabled) async {
    await prefs.setBool(_keyNotificationsEnabled, enabled);
  }

  static Future<String?> getCurrentUser() async {
    return prefs.getString(_keyCurrentUser);
  }

  static Future<void> setCurrentUser(String userId) async {
    await prefs.setString(_keyCurrentUser, userId);
  }

  static Future<void> clearCurrentUser() async {
    await prefs.remove(_keyCurrentUser);
  }

  static Future<User?> getUserProfile() async {
    final profileJson = prefs.getString(_keyUserProfile);
    if (profileJson == null) return null;

    try {
      final Map<String, dynamic> profileMap = json.decode(profileJson);
      return User(
        id: profileMap['id'] as String,
        name: profileMap['name'] as String,
        email: profileMap['email'] as String,
        avatarUrl: profileMap['avatarUrl'] as String?,
        joinDate: DateTime.parse(profileMap['joinDate'] as String),
        favoriteMoviesCount: profileMap['favoriteMoviesCount'] as int? ?? 0,
        watchlistCount: profileMap['watchlistCount'] as int? ?? 0,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveUserProfile(User user) async {
    final profileMap = {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'avatarUrl': user.avatarUrl,
      'joinDate': user.joinDate.toIso8601String(),
      'favoriteMoviesCount': user.favoriteMoviesCount,
      'watchlistCount': user.watchlistCount,
    };
    await prefs.setString(_keyUserProfile, json.encode(profileMap));
  }

  static Future<void> clearUserProfile() async {
    await prefs.remove(_keyUserProfile);
  }

  // Clear all preferences
  static Future<void> clearAll() async {
    await prefs.clear();
  }
}
