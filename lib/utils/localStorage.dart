import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static String saved_user_id_key = 'USER_ID';
  static String saved_user_pass_key = 'USER_PASS';

  static Future<bool> save_user_id(String user_id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(saved_user_id_key, user_id);
  }

  static Future<bool> save_user_pass(String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(saved_user_pass_key, password);
  }

  static Future<String?> get_user_id() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(saved_user_id_key);
  }

  static Future<String?> get_user_pass() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(saved_user_pass_key);
  }

  static Future<bool?> remove_user() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(saved_user_pass_key);
    return await preferences.remove(saved_user_id_key);
  }
}
