import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static late SharedPreferences _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // String methods
  static Future<bool> setString(String key, String value) async {
    return await _preferences.setString(key, value);
  }

  static String? getString(String key) {
    return _preferences.getString(key);
  }

  static String getStringOrDefault(String key, String defaultValue) {
    return _preferences.getString(key) ?? defaultValue;
  }

  // Boolean methods
  static Future<bool> setBool(String key, bool value) async {
    return await _preferences.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  static bool getBoolOrDefault(String key, bool defaultValue) {
    return _preferences.getBool(key) ?? defaultValue;
  }

  // Integer methods
  static Future<bool> setInt(String key, int value) async {
    return await _preferences.setInt(key, value);
  }

  static int? getInt(String key) {
    return _preferences.getInt(key);
  }

  static int getIntOrDefault(String key, int defaultValue) {
    return _preferences.getInt(key) ?? defaultValue;
  }

  // Double methods
  static Future<bool> setDouble(String key, double value) async {
    return await _preferences.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  static double getDoubleOrDefault(String key, double defaultValue) {
    return _preferences.getDouble(key) ?? defaultValue;
  }

  // String list methods
  static Future<bool> setStringList(String key, List<String> value) async {
    return await _preferences.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  static List<String> getStringListOrDefault(String key, List<String> defaultValue) {
    return _preferences.getStringList(key) ?? defaultValue;
  }

  // Utility methods
  static Future<bool> remove(String key) async {
    return await _preferences.remove(key);
  }

  static Future<bool> clear() async {
    return await _preferences.clear();
  }

  static bool containsKey(String key) {
    return _preferences.containsKey(key);
  }

  static Set<String> getKeys() {
    return _preferences.getKeys();
  }
}