import 'package:delightsome_software/dataModels/userModels/staff.model.dart';
import 'package:delightsome_software/globalvariables.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  // ! SENDERS

  // login
  static Future<bool> login(BuildContext context, Map data) async {
    // { staffId, password }
    return await sendDataToServer(context, route: 'login', data: data);
  }

  // reset password
  static Future<bool> reset_password(
      BuildContext context, String staff_id) async {
    return await sendDataToServer(context,
        route: 'reset_password/${staff_id}', data: {});
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
  static logout() {}
  //
}
