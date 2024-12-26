import 'package:delightsome_software/dataModels/userModels/staff.model.dart';
import 'package:delightsome_software/globalvariables.dart';
import 'package:delightsome_software/helpers/serverHelpers.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class AuthHelpers {
  // ! CONSTANTS
  static String authUrl = '${server_url}/api/auth';

  // Post Data to server
  static Future<bool> sendDataToServer(context,
      {required String route, required Map data}) async {
    // Json encode data
    var body = jsonEncode(data);

    UniversalHelpers.showLoadingScreen(context: context);
    try {
      var response = await http.post(Uri.parse('${authUrl}/${route}'),
          headers: {"Content-Type": "application/json"}, body: body);

      var jsonResponse = jsonDecode(response.body);

      // throw error message
      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      Navigator.pop(context);
      UniversalHelpers.showToast(
        context: context,
        color: Colors.green.shade500,
        toastText: jsonResponse['message'],
        icon: Icons.check,
      );

      return true;
    } catch (e) {
      Navigator.pop(context);
      UniversalHelpers.showToast(
        context: context,
        color: Colors.red,
        toastText: (e.toString().toLowerCase().contains('formatexception') ||
                e.toString().toLowerCase().contains('clientexception') ||
                e.toString().toLowerCase().contains('socketexception') ||
                e.toString().toLowerCase().contains('connection'))
            ? 'Connection Error. Try again later'
            : e.toString(),
        icon: Icons.check,
      );

      return false;
    }
  }

  static Future<dynamic> sendDataToServer_2(context,
      {required String route,
      required Map data,
      bool showLoading = false,
      bool showToast = true}) async {
    // Json encode data
    var body = jsonEncode(data);

    if (showLoading) UniversalHelpers.showLoadingScreen(context: context);
    try {
      var response = await http.post(Uri.parse('${authUrl}/${route}'),
          headers: {"Content-Type": "application/json"}, body: body);

      var jsonResponse = jsonDecode(response.body);

      // throw error message
      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      if (showLoading) Navigator.pop(context);

      return jsonResponse;
    } catch (e) {
      if (showLoading) Navigator.pop(context);
      if (showToast)
        UniversalHelpers.showToast(
          context: context,
          color: Colors.red,
          toastText: (e.toString().toLowerCase().contains('formatexception') ||
                  e.toString().toLowerCase().contains('clientexception') ||
                  e.toString().toLowerCase().contains('socketexception') ||
                  e.toString().toLowerCase().contains('connection'))
              ? 'Connection Error. Try again later'
              : e.toString(),
          icon: Icons.check,
        );

      return null;
    }
  }

  // ! SENDERS

  // login
  static Future<bool> login(BuildContext context, Map data) async {
    // { staffId, password }
    return await sendDataToServer(context, route: 'login', data: data);
  }

  // check_staff_id
  static Future<dynamic> check_staff_id(BuildContext context, Map data,
      {bool showLoading = false}) async {
    // { staffId, password }
    return await sendDataToServer_2(
      context,
      route: 'check_staff_id',
      data: data,
      showLoading: showLoading,
    );
  }

  // check_password
  static Future<dynamic> check_password(BuildContext context, Map data,
      {bool showLoading = false}) async {
    // { staffId, password }
    return await sendDataToServer_2(context,
        route: 'check_password', data: data, showLoading: showLoading);
  }

  // create_password
  static Future<dynamic> create_password(BuildContext context, Map data,
      {bool showLoading = false}) async {
    // { staffId, password }
    return await sendDataToServer_2(context,
        route: 'create_password', data: data, showLoading: showLoading);
  }

  // create_pin
  static Future<dynamic> create_pin(BuildContext context, Map data,
      {bool showLoading = false}) async {
    // { staffId, pin }
    return await sendDataToServer_2(context,
        route: 'create_pin', data: data, showLoading: showLoading);
  }

  // reset password
  static Future<bool> reset_password(
      BuildContext context, String staff_id) async {
    return await sendDataToServer(context,
        route: 'reset_password/${staff_id}', data: {});
  }

  // reset pin
  static Future<bool> reset_pin(BuildContext context, String staff_id) async {
    return await sendDataToServer(context,
        route: 'reset_pin/${staff_id}', data: {});
  }

  // ! GETTERS

  // get all staff
  static Future<List<StaffModel>> get_online_users() async {
    try {
      var response = await http.get(Uri.parse('${authUrl}/get_online_users'));

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<StaffModel> staffList = [];
      List staffs = jsonResponse['onlineUsersDb'];
      for (var staff in staffs) {
        StaffModel staffModel = StaffModel.fromJson(staff);

        staffList.add(staffModel);
      }

      return staffList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // get active staff
  static Future<StaffModel?> get_active_staff(String staff_id) async {
    try {
      var response =
          await http.get(Uri.parse('${authUrl}/get_active_staff/${staff_id}'));

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      if (jsonResponse['success'] != null && jsonResponse['success'] == true) {
        var staff = jsonResponse['staff'];
        StaffModel staffModel = StaffModel.fromJson(staff);
        return staffModel;
      } else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // ! UTILS
  static logout(BuildContext context) {
    saved_product_material_request_model = null;
    saved_raw_material_request_model = null;
    saved_restock_product_material_model = null;
    saved_restock_raw_material_model = null;

    saved_bad_product_model = null;
    saved_product_received_model = null;
    saved_product_request_model = null;
    saved_production_model = null;
    saved_terminal_collected_model = null;
    saved_terminal_returned_model = null;

    auth_pin = null;

    Provider.of<AppData>(context, listen: false).outlet_shops.clear();
    Provider.of<AppData>(context, listen: false).terminal_shops.clear();

    Provider.of<AppData>(context, listen: false).active_staff = null;
    ServerHelpers.disconnect_socket();
  }

  //
}
