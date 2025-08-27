import 'package:delightsome_software/dataModels/saleModels/dailystore.model.dart';
import 'package:delightsome_software/dataModels/saleModels/outletDailysales.model.dart';
import 'package:delightsome_software/dataModels/saleModels/sales.model.dart';
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

  // post getters
  static Future<http.Response> post_getters(context, String url_suffix) async {
    var auth_staff = Provider.of<AppData>(context, listen: false).active_staff;

    // add current user to data
    Map data = {"user": auth_staff?.key};
    // Json encode data
    var body = jsonEncode(data);
    return await http.post(Uri.parse('${salesUrl}/${url_suffix}'),
        headers: {"Content-Type": "application/json"}, body: body);
  }

  // ! GETTERS

  // Get store sales record
  static Future<List<SalesModel>> get_store_sales_record(context) async {
    try {
      var response = await post_getters(context, 'get_store_sales_record');

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

  // Get Outlet sales record
  static Future<List<SalesModel>> get_outlet_sales_record(context) async {
    try {
      var response = await post_getters(context, 'get_outlet_sales_record');

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
  static Future<List<SalesModel>> get_terminal_sales_record(context) async {
    try {
      var response = await post_getters(context, 'get_terminal_sales_record');

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

  // Get Dangote sales record
  static Future<List<SalesModel>> get_dangote_sales_record(context) async {
    try {
      var response = await post_getters(context, 'get_dangote_sales_record');

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

  //?

  // Get selected store sales record
  static Future<List<SalesModel>> get_selected_store_sales_record(
      BuildContext context, Map data) async {
    var map = await send_get_dataToServer(context,
        route: 'get_selected_store_sales_record', data: data);
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

  // Get selected Outlet sales record
  static Future<List<SalesModel>> get_selected_outlet_sales_record(
      BuildContext context, Map data) async {
    var map = await send_get_dataToServer(context,
        route: 'get_selected_outlet_sales_record', data: data);
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

  // Get selected Dangote sales record
  static Future<List<SalesModel>> get_selected_dangote_sales_record(
      BuildContext context, Map data) async {
    var map = await send_get_dataToServer(context,
        route: 'get_selected_dangote_sales_record', data: data);
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

  //?

  // Get daily store record
  static Future<List<DailyStoreModel>> get_daily_store_record(context) async {
    try {
      var response = await post_getters(context, 'get_daily_store_record');

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<DailyStoreModel> recordList = [];
      List record = jsonResponse['record'];
      for (var element in record) {
        DailyStoreModel recordModel = DailyStoreModel.fromJson(element);

        recordList.add(recordModel);
      }

      return recordList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Get outlet daily sales record
  static Future<List<OutletDailySalesModel>> get_outlet_daily_sales_record(
      context) async {
    try {
      var response =
          await post_getters(context, 'get_outlet_daily_sales_record');

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<OutletDailySalesModel> recordList = [];
      List record = jsonResponse['record'];
      for (var element in record) {
        OutletDailySalesModel recordModel =
            OutletDailySalesModel.fromJson(element);

        recordList.add(recordModel);
      }

      return recordList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Get terminal daily sales record
  static Future<List<OutletDailySalesModel>> get_terminal_daily_sales_record(
      context) async {
    try {
      var response =
          await post_getters(context, 'get_terminal_daily_sales_record');

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<OutletDailySalesModel> recordList = [];
      List record = jsonResponse['record'];
      for (var element in record) {
        OutletDailySalesModel recordModel =
            OutletDailySalesModel.fromJson(element);

        recordList.add(recordModel);
      }

      return recordList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Get dangote daily sales record
  static Future<List<OutletDailySalesModel>> get_dangote_daily_sales_record(
      context) async {
    try {
      var response =
          await post_getters(context, 'get_dangote_daily_sales_record');

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<OutletDailySalesModel> recordList = [];
      List record = jsonResponse['record'];
      for (var element in record) {
        OutletDailySalesModel recordModel =
            OutletDailySalesModel.fromJson(element);

        recordList.add(recordModel);
      }

      return recordList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  //?

  // Get selected daily sales record
  static Future<List<DailyStoreModel>> get_selected_daily_store_record(
      BuildContext context, Map data) async {
    var map = await send_get_dataToServer(context,
        route: 'get_selected_daily_store_record', data: data);
    List<DailyStoreModel> recordList = [];

    if (map != null) {
      List record = map['record'] ?? [];
      for (var item in record) {
        DailyStoreModel recordModel = DailyStoreModel.fromJson(item);

        recordList.add(recordModel);
      }
    }

    return recordList;
  }

  // Get selected outlet daily sales record
  static Future<List<OutletDailySalesModel>>
      get_selected_outlet_daily_sales_record(
          BuildContext context, Map data) async {
    var map = await send_get_dataToServer(context,
        route: 'get_selected_outlet_daily_sales_record', data: data);
    List<OutletDailySalesModel> recordList = [];

    if (map != null) {
      List record = map['record'] ?? [];
      for (var item in record) {
        OutletDailySalesModel recordModel =
            OutletDailySalesModel.fromJson(item);

        recordList.add(recordModel);
      }
    }

    return recordList;
  }

  // Get selected terminal daily sales record
  static Future<List<OutletDailySalesModel>>
      get_selected_terminal_daily_sales_record(
          BuildContext context, Map data) async {
    var map = await send_get_dataToServer(context,
        route: 'get_selected_terminal_daily_sales_record', data: data);
    List<OutletDailySalesModel> recordList = [];

    if (map != null) {
      List record = map['record'] ?? [];
      for (var item in record) {
        OutletDailySalesModel recordModel =
            OutletDailySalesModel.fromJson(item);

        recordList.add(recordModel);
      }
    }

    return recordList;
  }

  // Get selected dangote daily sales record
  static Future<List<OutletDailySalesModel>>
      get_selected_dangote_daily_sales_record(
          BuildContext context, Map data) async {
    var map = await send_get_dataToServer(context,
        route: 'get_selected_dangote_daily_sales_record', data: data);
    List<OutletDailySalesModel> recordList = [];

    if (map != null) {
      List record = map['record'] ?? [];
      for (var item in record) {
        OutletDailySalesModel recordModel =
            OutletDailySalesModel.fromJson(item);

        recordList.add(recordModel);
      }
    }

    return recordList;
  }

  // ! SETTERS

  // Enter new sale
  static Future<List> enter_new_store_sale(
      BuildContext context, Map data) async {
    return await sendShopDataToServer(context,
        route: 'enter_new_store_sale', data: data);
  }

  // Enter new outlet Sales
  static Future<List> enter_new_outlet_sale(
      BuildContext context, Map data) async {
    return await sendShopDataToServer(context,
        route: 'enter_new_outlet_sale', data: data);
  }

  // Enter new terminal Sales
  static Future<List> enter_new_terminal_sale(
      BuildContext context, Map data) async {
    return await sendShopDataToServer(context,
        route: 'enter_new_terminal_sale', data: data);
  }

  // Enter new dangote Sales
  static Future<List> enter_new_dangote_sale(
      BuildContext context, Map data) async {
    return await sendShopDataToServer(context,
        route: 'enter_new_dangote_sale', data: data);
  }

  // ! REMOVALS

  // Delete Sale record
  static Future<bool> delete_store_sale_record(
      BuildContext context, String id) async {
    return await deleteFromServer(context,
        route: 'delete_store_sale_record', id: id);
  }

    // Delete Outlet Sale record
  static Future<bool> delete_outlet_sale_record(
      BuildContext context, String id) async {
    return await deleteFromServer(context,
        route: 'delete_outlet_sale_record', id: id);
  }

  // Delete Terminal Sale record
  static Future<bool> delete_terminal_sale_record(
      BuildContext context, String id) async {
    return await deleteFromServer(context,
        route: 'delete_terminal_sale_record', id: id);
  }

  // Delete Dangote Sale record
  static Future<bool> delete_dangote_sale_record(
      BuildContext context, String id) async {
    return await deleteFromServer(context,
        route: 'delete_dangote_sale_record', id: id);
  }

  //
}
