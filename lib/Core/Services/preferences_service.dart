import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _themeKey = 'theme_mode';
  static const _languageKey = 'language_code';

  SharedPreferences? _prefs;

  Future<void> _ensureInitialized() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
    } catch (e) {
      print('SharedPreferences initialization failed: $e');
      // You might want to use a fallback storage or retry logic here
      throw Exception('Failed to initialize SharedPreferences: $e');
    }
  }

  Future<void> saveTheme(bool isDarkMode) async {
    try {
      await _ensureInitialized();
      await _prefs!.setBool(_themeKey, isDarkMode);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving theme: $e');
      }
      // Handle error appropriately
    }
  }

  Future<bool> getTheme() async {
    try {
      await _ensureInitialized();
      return _prefs!.getBool(_themeKey) ?? true;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading theme: $e');
      }
      return true; // Default to dark mode
    }
  }

  Future<void> saveLanguage(String languageCode) async {
    try {
      await _ensureInitialized();
      await _prefs!.setString(_languageKey, languageCode);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving language: $e');
      }
    }
  }

  Future<String> getLanguage() async {
    try {
      await _ensureInitialized();
      return _prefs!.getString(_languageKey) ?? 'en';
    } catch (e) {
      if (kDebugMode) {
        print('Error loading language: $e');
      }
      return 'en'; // Default to English
    }
  }
}