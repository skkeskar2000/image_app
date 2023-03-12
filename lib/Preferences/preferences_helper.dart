
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static SharedPreferences? _preferences;

  static Future init() async {
    print("Preferences init");
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setString(String key, String value) async =>
      await _preferences?.setString(key, value);

  static String? getString(String key) => _preferences!.getString(key) ?? "N/A";

  static Future setBoolean(String key, bool value) async =>
      await _preferences?.setBool(key, value);

  static bool getBoolean(String key) => _preferences!.getBool(key) ?? false;

  static int getInt(dynamic key) {
    return _preferences!.getInt("$key") ?? 0;
  }

  static Future setInt(String key, int value) async {
    return await _preferences!.setInt(key, value);
  }

  static Future setStringList(String key,List<String>value)async{
    return await _preferences!.setStringList(key, value);
  }
  static Future<List<String>?> getStringList(String key)async{
    return _preferences!.getStringList(key);
  }
  static void clearPref() {
    _preferences!.clear();
  }

}
