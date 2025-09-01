import 'dart:convert';

import 'package:delightsome_software/dataModels/userModels/auth.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Localstorage {
  static String saved_accounts_key = 'ACCOUNTS';
  static String saved_active_account_key = 'ACTIVE_ACCOUNT';

  static String offline_data_key = 'OFFLINE_KEY';

  static Future<bool> save_accounts(List<AuthModel> accounts) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    List<String> jsonStringList =
        accounts.map((account) => jsonEncode(account.toJson())).toList();
    return await preferences.setStringList(saved_accounts_key, jsonStringList);
  }

  static Future<bool> save_active_account(AuthModel? account) async {
    if (account == null) return false;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(
        saved_active_account_key, jsonEncode(account.toJson()));
  }

  static Future<List<AuthModel>> get_accounts() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    List<String>? jsonStringList =
        preferences.getStringList(saved_accounts_key);

    if (jsonStringList != null) {
      return jsonStringList
          .map((jsonString) => AuthModel.fromJson(jsonDecode(jsonString)))
          .toList();
    }

    return [];
  }

  static Future<AuthModel?> get_active_account() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? jsonString = preferences.getString(saved_active_account_key);

    if (jsonString != null) {
      return AuthModel.fromJson(jsonDecode(jsonString));
    }

    return null;
  }

  static Future<bool?> remove_accounts() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.remove(saved_accounts_key);
  }

  static Future<bool?> remove_active_account() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.remove(saved_active_account_key);
  }

}
