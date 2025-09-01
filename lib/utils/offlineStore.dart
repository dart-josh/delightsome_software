import 'dart:convert';
import 'package:delightsome_software/globalvariables.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineStore {
  static late SharedPreferences preferences;

  static init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static String offline_data_key = 'OFFLINE_KEY';

  //? GETTERS

  static Future<List> get_data(String key) async {
    List<String>? jsonStringList = preferences.getStringList(key);

    if (jsonStringList != null) {
      return jsonStringList
          .map((jsonString) => jsonDecode(jsonString))
          .toList();
    }

    return [];
  }

  static Future<List<dynamic>> get_offline_data({bool building = false}) async {
    List<String>? jsonStringList = preferences.getStringList(offline_data_key);

    List result = [];

    if (jsonStringList != null) {
      result =
          jsonStringList.map((jsonString) => jsonDecode(jsonString)).toList();
    }

    if (!building) offline_data.value = result;

    return result;
  }

  //? SETTERS

  static Future<bool> save_data(String key, List data) async {
    List<String> jsonStringList =
        data.map((account) => jsonEncode(account)).toList();
    return await preferences.setStringList(key, jsonStringList);
  }

  static Future<bool> update_offline_data(Map new_data) async {
    if (new_data['data'] == null || new_data['data'] == {}) return false;
    if (new_data['endpoint'] == null || new_data['endpoint'] == '')
      return false;

    var init_data = await get_offline_data();

    Map toJ = {
      'key': UniversalHelpers.generate_key(),
      'date': DateTime.now().toString(),
      ...new_data,
    };
    init_data.add(toJ);

    offline_data.value = init_data;

    List<String> jsonStringList =
        init_data.map((data) => jsonEncode(data)).toList();
    return await preferences.setStringList(offline_data_key, jsonStringList);
  }

  //? REMOVALS

  static Future<bool?> clear_data(String key) async {
    return await preferences.remove(key);
  }

  static Future<bool> delete_offline_data(String key) async {
    var init_data = await get_offline_data();

    int chk = init_data.indexWhere((e) => e['key'] == key);

    if (chk != -1) {
      init_data.removeAt(chk);
    } else
      return false;

    List<String> jsonStringList =
        init_data.map((data) => jsonEncode(data)).toList();
    return await preferences.setStringList(offline_data_key, jsonStringList);
  }

  static Future<bool?> clear_offline_data() async {
    return await preferences.remove(offline_data_key);
  }

  //? UTILS

  static bool isOffline(String? id) {
    if (id == null) return false;
    var chk = offline_data.value.where((e) => e['id'] == id);
    return chk.isNotEmpty;
  }

  //
}
