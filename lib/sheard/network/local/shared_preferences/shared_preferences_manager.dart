import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static SharedPreferences? sharedPreferences;

  static void initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static void saveString(String key, String value) async {
    await sharedPreferences!.setString(key, value);
  }

  static String? getString(String key) {
    return sharedPreferences!.getString(key);
  }
}
