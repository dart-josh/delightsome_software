import 'package:delightsome_software/dataModels/userModels/customer.model.dart';
import 'package:delightsome_software/dataModels/userModels/staff.model.dart';
import 'package:delightsome_software/globalvariables.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserHelpers {
  static String usersUrl = '${server_url}/api/users';

  // Post Data to server
  static Future<bool> sendDataToServer(context,
      {required String route, required Map data}) async {
    if (activeStaff == null) {
      UniversalHelpers.showToast(
        context: context,
        color: Colors.red,
        toastText: 'No User Found',
        icon: Icons.error,
      );
      return false;
    }

    // add current user to data
    data.addAll({"user": activeStaff!.key!});
    // Json encode data
    var body = jsonEncode(data);

    UniversalHelpers.showLoadingScreen(context: context);
    try {
      var response = await http.post(Uri.parse('${server_url}/${route}'),
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

  // Delete Data from sever
  static Future<bool> deleteFromServer(context,
      {required String route, required String id}) async {
    if (activeStaff == null) {
      UniversalHelpers.showToast(
        context: context,
        color: Colors.red,
        toastText: 'No User Found',
        icon: Icons.error,
      );
      return false;
    }

    // add current user to data
    Map data = {'user': activeStaff!.key!};
    // Json encode data
    var body = jsonEncode(data);

    UniversalHelpers.showLoadingScreen(context: context);
    try {
      var response = await http.delete(Uri.parse('${server_url}/${route}/$id'),
          headers: {"Content-Type": "application/json"}, body: body);

      var jsonResponse = jsonDecode(response.body);

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

  // ! GETTERS

  // get all staff
  static Future<List<StaffModel>> get_all_staff() async {
    try {
      var response = await http.get(Uri.parse('${usersUrl}/get_all_staff'));

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<StaffModel> staffList = [];
      List staffs = jsonResponse['staffs'];
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

  // get all customer
  static Future<List<CustomerModel>> get_all_customer() async {
    try {
      var response = await http.get(Uri.parse('${usersUrl}/get_all_customer'));

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<CustomerModel> customerList = [];
      List customers = jsonResponse['customers'];
      for (var customer in customers) {
        CustomerModel customerModel = CustomerModel.fromJson(customer);

        customerList.add(customerModel);
      }

      return customerList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // get active staff
  static Future<StaffModel?> get_active_staff() async {
     
  }

  // ! SETTERS

  // Add/update staff
  static Future<bool> add_update_staff(BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'add_update_staff', data: data);
  }

  // Add/Update customers
  static Future<bool> add_update_customer(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'add_update_customer', data: data);
  }

  // ! REMOVALS

  // delete staff
  static Future<bool> delete_staff(BuildContext context, String id) async {
    return await deleteFromServer(context, route: 'delete_staff', id: id);
  }

  // delete customer
  static Future<bool> delete_customer(BuildContext context, String id) async {
    return await deleteFromServer(context, route: 'delete_customer', id: id);
  }
}
