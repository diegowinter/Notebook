import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<void> saveString(String key, String value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key, value);
  }

  static Future<void> saveMap(String key, Map<String, dynamic> value) async {
    saveString(key, json.encode(value));
  }

  static Future<void> saveBool(String key, bool value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(key, value);
  }

  static Future<String?> getString(String key) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getString(key);
  }

  static Future<Map<String, dynamic>?> getMap(String key) async {
    try {
      Map<String, dynamic> map = json.decode(await getString(key) ?? '');
      return map;
    } catch (_) {
      return null;
    }
  }

  static Future<bool?> getBool(String key) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getBool(key);
  }

  static Future<bool> remove(String key) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.remove(key);
  }
}
