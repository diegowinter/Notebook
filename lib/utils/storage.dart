import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<void> saveString(String key, String value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key, value);
  }

  static Future<void> saveBool(String key, bool value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(key, value);
  }

  static Future<String?> getString(String key) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    
    return sharedPreferences.getString(key);
  }

  static Future<bool?> getBool(String key) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getBool(key);
  }
}