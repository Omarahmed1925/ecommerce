import 'package:shared_preferences/shared_preferences.dart';

class CacheKeys {
  static const String token = 'token';
  static const String userName = 'userName';
  static const String userEmail = 'userEmail';
  static const String userPhone = 'userPhone';
}

class SharedPreferencesUtils {
  static late SharedPreferences sharedPreferences;

  static Future<SharedPreferences> getInstance() async {
    return sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) {
      return sharedPreferences.setString(key, value);
    } else if (value is int) {
      return sharedPreferences.setInt(key, value);
    } else if (value is bool) {
      return sharedPreferences.setBool(key, value);
    } else if (value is double) {
      return sharedPreferences.setDouble(key, value);
    } else if (value is List<String>) {
      return sharedPreferences.setStringList(key, value);
    }
    return false;
  }

  static readData({required String key}) {
    return sharedPreferences.get(key);
  }

  static Future<bool> removeData({required String key}) {
    return sharedPreferences.remove(key);
  }
}
