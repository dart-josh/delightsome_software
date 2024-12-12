import 'package:delightsome_software/dataModels/saleModels/dailysales.model.dart';
import 'package:delightsome_software/dataModels/saleModels/sales.model.dart';
import 'package:delightsome_software/dataModels/saleModels/terminalDailysales.model.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:http/http.dart' as http;
import 'package:delightsome_software/globalvariables.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class SaleHelpers {
  // ! CONSTANTS
  static String salesUrl = '${server_url}/api/sales';

  // Post Data to server
  static Future<bool> sendDataToServer(context,
      {required String route, required Map data}) async {
    var auth_staff = Provider.of<AppData>(context, listen: false).active_staff;

    if (auth_staff == null) {
      UniversalHelpers.showToast(
        context: context,
        color: Colors.red,
        toastText: 'No User Found',
        icon: Icons.error,
      );
      return false;
    }

    // add current user to data
    data.addAll({"user": auth_staff.key!});
    // Json encode data
    var body = jsonEncode(data);

    UniversalHelpers.showLoadingScreen(context: context);
    try {
      var response = await http.post(Uri.parse('${salesUrl}/${route}'),
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

  // Post fetch Data to server
  static Future<dynamic> send_get_dataToServer(context,
      {required String route, required Map data}) async {
    var auth_staff = Provider.of<AppData>(context, listen: false).active_staff;

    if (auth_staff == null) {
      UniversalHelpers.showToast(
        context: context,
        color: Colors.red,
        toastText: 'No User Found',
        icon: Icons.error,
      );
      return {};
    }

    // add current user to data
    data.addAll({'user': auth_staff.key!});
    // Json encode data
    var body = jsonEncode(data);

    // UniversalHelpers.showLoadingScreen(context: context);
    try {
      var response = await http.post(Uri.parse('${salesUrl}/${route}'),
          headers: {"Content-Type": "application/json"}, body: body);

      var jsonResponse = jsonDecode(response.body);

      // throw error message
      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      // Navigator.pop(context);

      return jsonResponse;
    } catch (e) {
      // Navigator.pop(context);
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

      return {};
    }
  }

  // Post Data to server
  static Future<List> sendShopDataToServer(context,
      {required String route, required Map data}) async {
    var auth_staff = Provider.of<AppData>(context, listen: false).active_staff;

    if (auth_staff == null) {
      UniversalHelpers.showToast(
        context: context,
        color: Colors.red,
        toastText: 'No User Found',
        icon: Icons.error,
      );
      return [false, ''];
    }

    // add current user to data
    data.addAll({"user": auth_staff.key!});
    // Json encode data
    var body = jsonEncode(data);

    UniversalHelpers.showLoadingScreen(context: context);
    try {
      var response = await http.post(Uri.parse('${salesUrl}/${route}'),
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

      return [true, jsonResponse['newSale']['orderId']];
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

      return [false, ''];
    }
  }

  // Delete Data from sever
  static Future<bool> deleteFromServer(context,
      {required String route, required String id}) async {
    var auth_staff = Provider.of<AppData>(context, listen: false).active_staff;

    if (auth_staff == null) {
      UniversalHelpers.showToast(
        context: context,
        color: Colors.red,
        toastText: 'No User Found',
        icon: Icons.error,
      );
      return false;
    }

    // add current user to data
    Map data = {'user': auth_staff.key!};
    // Json encode data
    var body = jsonEncode(data);

    UniversalHelpers.showLoadingScreen(context: context);
    try {
      var response = await http.delete(Uri.parse('${salesUrl}/${route}/$id'),
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

  // Get sales record
  static Future<List<SalesModel>> get_sales_record() async {
    try {
      var response = await http.get(Uri.parse('${salesUrl}/get_sales_record'));

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<SalesModel> recordList = [];
      List record = jsonResponse['record'];
      for (var element in record) {
        SalesModel recordModel = SalesModel.fromJson(element);

        recordList.add(recordModel);
      }

      return recordList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Get Terminal sales record
  static Future<List<SalesModel>> get_terminal_sales_record() async {
    try {
      var response =
          await http.get(Uri.parse('${salesUrl}/get_terminal_sales_record'));

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<SalesModel> recordList = [];
      List record = jsonResponse['record'];
      for (var element in record) {
        SalesModel recordModel = SalesModel.fromJson(element);

        recordList.add(recordModel);
      }

      return recordList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Get selected sales record
  static Future<List<SalesModel>> get_selected_sales_record(
      BuildContext context, Map data) async {
    var map = await send_get_dataToServer(context,
        route: 'get_selected_sales_record', data: data);
    List<SalesModel> recordList = [];

    if (map != null) {
      List record = map['record'] ?? [];
      for (var item in record) {
        SalesModel recordModel = SalesModel.fromJson(item);

        recordList.add(recordModel);
      }
    }

    return recordList;
  }

// Get selected Terminal sales record
  static Future<List<SalesModel>> get_selected_terminal_sales_record(
      BuildContext context, Map data) async {
    var map = await send_get_dataToServer(context,
        route: 'get_selected_terminal_sales_record', data: data);
    List<SalesModel> recordList = [];

    if (map != null) {
      List record = map['record'] ?? [];
      for (var item in record) {
        SalesModel recordModel = SalesModel.fromJson(item);

        recordList.add(recordModel);
      }
    }

    return recordList;
  }

  // Get daily sales record
  static Future<List<DailySalesModel>> get_daily_sales_record() async {
    try {
      var response =
          await http.get(Uri.parse('${salesUrl}/get_daily_sales_record'));

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<DailySalesModel> recordList = [];
      List record = jsonResponse['record'];
      for (var element in record) {
        DailySalesModel recordModel = DailySalesModel.fromJson(element);

        recordList.add(recordModel);
      }

      return recordList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Get terminal daily sales record
  static Future<List<TerminalDailySalesModel>>
      get_terminal_daily_sales_record() async {
    try {
      var response = await http
          .get(Uri.parse('${salesUrl}/get_terminal_daily_sales_record'));

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<TerminalDailySalesModel> recordList = [];
      List record = jsonResponse['record'];
      for (var element in record) {
        TerminalDailySalesModel recordModel =
            TerminalDailySalesModel.fromJson(element);

        recordList.add(recordModel);
      }

      return recordList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Get selected daily sales record
  static Future<List<DailySalesModel>> get_selected_daily_sales_record(
      BuildContext context, Map data) async {
    var map = await send_get_dataToServer(context,
        route: 'get_selected_daily_sales_record', data: data);
    List<DailySalesModel> recordList = [];

    if (map != null) {
      List record = map['record'] ?? [];
      for (var item in record) {
        DailySalesModel recordModel = DailySalesModel.fromJson(item);

        recordList.add(recordModel);
      }
    }

    return recordList;
  }

  // Get selected terminal daily sales record
  static Future<List<TerminalDailySalesModel>>
      get_selected_terminal_daily_sales_record(
          BuildContext context, Map data) async {
    var map = await send_get_dataToServer(context,
        route: 'get_selected_terminal_daily_sales_record', data: data);
    List<TerminalDailySalesModel> recordList = [];

    if (map != null) {
      List record = map['record'] ?? [];
      for (var item in record) {
        TerminalDailySalesModel recordModel =
            TerminalDailySalesModel.fromJson(item);

        recordList.add(recordModel);
      }
    }

    return recordList;
  }

  // ! SETTERS

  // Enter new sale
  static Future<List> enter_new_sale(BuildContext context, Map data) async {
    return await sendShopDataToServer(context,
        route: 'enter_new_sale', data: data);
  }

  // Enter new terminal Sales
  static Future<List> enter_new_terminal_sale(
      BuildContext context, Map data) async {
    return await sendShopDataToServer(context,
        route: 'enter_new_terminal_sale', data: data);
  }

  // ! REMOVALS

  // Delete Sale record
  static Future<bool> delete_sale_record(
      BuildContext context, String id) async {
    return await deleteFromServer(context, route: 'delete_sale_record', id: id);
  }

  // Delete Terminal Sale record
  static Future<bool> delete_terminal_sale_record(
      BuildContext context, String id) async {
    return await deleteFromServer(context,
        route: 'delete_terminal_sale_record', id: id);
  }
}
