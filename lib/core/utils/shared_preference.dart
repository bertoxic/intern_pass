import 'package:shared_preferences/shared_preferences.dart';

import '../../src/ui/state/providers/utility_provider.dart';
import '../../ui/state/providers/utility_provider.dart';

class SharedPreferencesUtil {
  static SharedPreferences? _prefs;
  static bool _sharedprefsinitialized = false;
  late UtilityProvider utilityProvider;

  /// Initialize SharedPreferences instance
  static Future<void> init() async {
    if (!_sharedprefsinitialized) {
      _prefs = await SharedPreferences.getInstance();
      _sharedprefsinitialized = true;
    }
  }

  /// Get the SharedPreferences instance
  static Future<SharedPreferences> getInstance() async {
    if (!_sharedprefsinitialized) {
      await init();
    }
    return _prefs!;
  }

  /// Save a string value
  static Future<bool> saveString(String key, String value) async {
    try {
      if (key.isEmpty) {
        throw ArgumentError('Key cannot be empty');
      }
      final prefs = await getInstance();
      return await prefs.setString(key, value);
    } catch (e) {
      print('Error saving string: $e');
      return false;
    }
  }

  /// Get a string value
  static Future<String?> getString(String key, {String? defaultValue}) async {
    try {
      if (key.isEmpty) {
        throw ArgumentError('Key cannot be empty');
      }
      final prefs = await getInstance();
      return prefs.getString(key) ?? defaultValue;
    } catch (e) {
      print('Error getting string: $e');
      return defaultValue;
    }
  }

  /// Save an integer value
  static Future<bool> saveInt(String key, int value) async {
    try {
      if (key.isEmpty) {
        throw ArgumentError('Key cannot be empty');
      }
      final prefs = await getInstance();
      return await prefs.setInt(key, value);
    } catch (e) {
      print('Error saving integer: $e');
      return false;
    }
  }

  /// Get an integer value
  static Future<int?> getInt(String key, {int? defaultValue}) async {
    try {
      if (key.isEmpty) {
        throw ArgumentError('Key cannot be empty');
      }
      final prefs = await getInstance();
      return prefs.getInt(key) ?? defaultValue;
    } catch (e) {
      print('Error getting integer: $e');
      return defaultValue;
    }
  }

  /// Save a boolean value
  static Future<bool> saveBool(String key, bool value) async {
    try {
      if (key.isEmpty) {
        throw ArgumentError('Key cannot be empty');
      }
      final prefs = await getInstance();
      return await prefs.setBool(key, value);
    } catch (e) {
      print('Error saving boolean: $e');
      return false;
    }
  }

  /// Get a boolean value
  static Future<bool?> getBool(String key, {bool? defaultValue}) async {
    try {
      if (key.isEmpty) {
        throw ArgumentError('Key cannot be empty');
      }
      final prefs = await getInstance();
      return prefs.getBool(key) ?? defaultValue;
    } catch (e) {
      print('Error getting boolean: $e');
      return defaultValue;
    }
  }

  /// Remove a value by key
  static Future<bool> remove(String key) async {
    try {
      if (key.isEmpty) {
       // throw ArgumentError('Key cannot be empty');
        print("key is empty");
      }
      final prefs = await getInstance();
      return await prefs.remove(key);
    } catch (e) {
      print('Error removing key: $e');
      return false;
    }
  }

  /// Clear all stored preferences
  static Future<bool> clearAll() async {
    try {
      final prefs = await getInstance();
      return await prefs.clear();
    } catch (e) {
      print('Error clearing preferences: $e');
      return false;
    }
  }

  /// Check if a key exists
  static Future<bool> containsKey(String key) async {
    try {
      if (key.isEmpty) {
        throw ArgumentError('Key cannot be empty');
      }
      final prefs = await getInstance();
      return prefs.containsKey(key);
    } catch (e) {
      print('Error checking key existence: $e');
      return false;
    }
  }
}