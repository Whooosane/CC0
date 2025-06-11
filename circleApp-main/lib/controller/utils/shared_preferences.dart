import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  static late SharedPreferences _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> reload() async {
    _preferences.reload();
  }

  static containKey(String key) {
    return _preferences.containsKey(key);
  }

  static setString(String key, String value) {
    return _preferences.setString(key, value);
  }

  static String getString(String key) {
    return _preferences.getString(key) ?? "";
  }

  static setBool(String key, bool value) {
    return _preferences.setBool(key, value);
  }

  static bool getBool(String key) {
    return _preferences.getBool(key) ?? false;
  }

  static setInt(String key, int value) {
    return _preferences.setInt(key, value);
  }

  static int getInt(String key) {
    return _preferences.getInt(key) ?? 0;
  }

  static removeKey(String key) {
    return _preferences.remove(key) ?? '';
  }

  static Future<void> removeAll() async {
    await _preferences.clear();
  }

  static Future<void> setListString(String key, List<String> interests) async {
    await _preferences.setString(key, interests.join(','));
  }

  // Get interests as a list of strings
  static List<String> getListString(String key) {
    String interestsString = _preferences.getString(key) ?? '';
    return interestsString.split(',').where((interest) => interest.isNotEmpty).toList();
  }
}
