import 'dart:convert';
import 'package:delightsome_software/dataModels/category.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/badProductRecord.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/dangoteCollectionRecord.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/product.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/productReceivedRecord.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/productRequestRecord.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/productReturnRecord.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/productTakeOutRecord.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/productionRecord.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/terminalCollectionRecord.model.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:http/http.dart' as http;
import 'package:delightsome_software/globalvariables.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductStoreHelpers {
  // ! CONSTANTS
  static String productStoreUrl = '${server_url}/api/productstore';

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
      var response = await http.post(Uri.parse('${productStoreUrl}/${route}'),
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
      var response = await http.post(Uri.parse('${productStoreUrl}/${route}'),
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
      var response = await http.delete(
          Uri.parse('${productStoreUrl}/${route}/$id'),
          headers: {"Content-Type": "application/json"},
          body: body);

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
    return await http.post(Uri.parse('${productStoreUrl}/${url_suffix}'),
        headers: {"Content-Type": "application/json"}, body: body);
  }

  // ! GETTERS

  // Get all products
  static Future<List<ProductModel>> get_products(context) async {
    try {
      var response = await post_getters(context, 'get_products');

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<ProductModel> productList = [];
      List products = jsonResponse['products'];
      for (var product in products) {
        ProductModel productModel = ProductModel.fromJson(product);

        productList.add(productModel);
      }

      return productList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // get terminal products
  static Future<List<ProductModel>> get_terminal_products(context) async {
    try {
      var response = await post_getters(context, 'get_terminal_products');

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<ProductModel> productList = [];
      List products = jsonResponse['products'];
      for (var product in products) {
        ProductModel productModel = ProductModel.fromJson(product);

        productList.add(productModel);
      }

      return productList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // get dangote products
  static Future<List<ProductModel>> get_dangote_products(context) async {
    try {
      var response = await post_getters(context, 'get_dangote_products');

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<ProductModel> productList = [];
      List products = jsonResponse['products'];
      for (var product in products) {
        ProductModel productModel = ProductModel.fromJson(product);

        productList.add(productModel);
      }

      return productList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // get production record
  static Future<List<ProductionRecordModel>> get_production_record(
      context) async {
    try {
      var response = await post_getters(context, 'get_production_record');

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<ProductionRecordModel> recordList = [];
      List record = jsonResponse['record'];
      for (var element in record) {
        ProductionRecordModel recordModel =
            ProductionRecordModel.fromJson(element);

        recordList.add(recordModel);
      }

      return recordList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Get product received record
  static Future<List<ProductReceivedRecordModel>> get_product_received_record(
      context) async {
    try {
      var response = await post_getters(context, 'get_product_received_record');

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<ProductReceivedRecordModel> recordList = [];
      List record = jsonResponse['record'];
      for (var element in record) {
        ProductReceivedRecordModel recordModel =
            ProductReceivedRecordModel.fromJson(element);

        recordList.add(recordModel);
      }

      return recordList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Get product request record
  static Future<List<ProductRequestRecordModel>> get_product_request_record(
      context) async {
    try {
      var response = await post_getters(context, 'get_product_request_record');

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<ProductRequestRecordModel> recordList = [];
      List record = jsonResponse['record'];
      for (var element in record) {
        ProductRequestRecordModel recordModel =
            ProductRequestRecordModel.fromJson(element);

        recordList.add(recordModel);
      }

      return recordList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Get product takeOut record
  static Future<List<ProductTakeOutRecordModel>> get_product_takeOut_record(
      context) async {
    try {
      var response = await post_getters(context, 'get_product_takeOut_record');

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<ProductTakeOutRecordModel> recordList = [];
      List record = jsonResponse['record'];
      for (var element in record) {
        ProductTakeOutRecordModel recordModel =
            ProductTakeOutRecordModel.fromJson(element);

        recordList.add(recordModel);
      }

      return recordList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Get product return record
  static Future<List<ProductReturnRecordModel>> get_product_return_record(
      context) async {
    try {
      var response = await post_getters(context, 'get_product_return_record');

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<ProductReturnRecordModel> recordList = [];
      List record = jsonResponse['record'];
      for (var element in record) {
        ProductReturnRecordModel recordModel =
            ProductReturnRecordModel.fromJson(element);

        recordList.add(recordModel);
      }

      return recordList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Get bad product record
  static Future<List<BadProductRecordModel>> get_bad_product_record(
      context) async {
    try {
      var response = await post_getters(context, 'get_bad_product_record');

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<BadProductRecordModel> recordList = [];
      List record = jsonResponse['record'];
      for (var element in record) {
        BadProductRecordModel recordModel =
            BadProductRecordModel.fromJson(element);

        recordList.add(recordModel);
      }

      return recordList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Get Terminal collection record
  static Future<List<TerminalCollectionRecordModel>>
      get_terminalCollection_record(context) async {
    try {
      var response =
          await post_getters(context, 'get_terminalCollection_record');

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<TerminalCollectionRecordModel> recordList = [];
      List record = jsonResponse['record'];
      for (var element in record) {
        TerminalCollectionRecordModel recordModel =
            TerminalCollectionRecordModel.fromJson(element);

        recordList.add(recordModel);
      }

      return recordList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Get Dangote collection record
  static Future<List<DangoteCollectionRecordModel>>
      get_dangoteCollection_record(context) async {
    try {
      var response =
          await post_getters(context, 'get_dangoteCollection_record');

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<DangoteCollectionRecordModel> recordList = [];
      List record = jsonResponse['record'];
      for (var element in record) {
        DangoteCollectionRecordModel recordModel =
            DangoteCollectionRecordModel.fromJson(element);

        recordList.add(recordModel);
      }

      return recordList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // get product categories
  static Future<List<CategoryModel>> get_product_categories(context) async {
    try {
      var response = await post_getters(context, 'get_product_categories');

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<CategoryModel> categories = [];
      List items = jsonResponse['categories'];
      for (var item in items) {
        CategoryModel categoryModel = CategoryModel.fromJson(item);

        categories.add(categoryModel);
      }

      return categories;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // ! SELECTED GETTERS

// Get selected production record
  static Future<List<ProductionRecordModel>> get_selected_production_record(
      BuildContext context, Map data) async {
    var map = await send_get_dataToServer(context,
        route: 'get_selected_production_record', data: data);
    List<ProductionRecordModel> recordList = [];

    if (map != null) {
      List record = map['record'] ?? [];
      for (var item in record) {
        ProductionRecordModel recordModel =
            ProductionRecordModel.fromJson(item);

        recordList.add(recordModel);
      }
    }

    return recordList;
  }

  // Get selected product received record
  static Future<List<ProductReceivedRecordModel>>
      get_selected_product_received_record(
          BuildContext context, Map data) async {
    var map = await send_get_dataToServer(context,
        route: 'get_selected_product_received_record', data: data);
    List<ProductReceivedRecordModel> recordList = [];

    if (map != null) {
      List record = map['record'] ?? [];
      for (var item in record) {
        ProductReceivedRecordModel recordModel =
            ProductReceivedRecordModel.fromJson(item);

        recordList.add(recordModel);
      }
    }

    return recordList;
  }

  // Get selected product request record
  static Future<List<ProductRequestRecordModel>>
      get_selected_product_request_record(
          BuildContext context, Map data) async {
    var map = await send_get_dataToServer(context,
        route: 'get_selected_product_request_record', data: data);
    List<ProductRequestRecordModel> recordList = [];

    if (map != null) {
      List record = map['record'] ?? [];
      for (var item in record) {
        ProductRequestRecordModel recordModel =
            ProductRequestRecordModel.fromJson(item);

        recordList.add(recordModel);
      }
    }

    return recordList;
  }

  // Get selected product takeOut record
  static Future<List<ProductTakeOutRecordModel>>
      get_selected_product_takeOut_record(
          BuildContext context, Map data) async {
    var map = await send_get_dataToServer(context,
        route: 'get_selected_product_takeOut_record', data: data);
    List<ProductTakeOutRecordModel> recordList = [];

    if (map != null) {
      List record = map['record'] ?? [];
      for (var item in record) {
        ProductTakeOutRecordModel recordModel =
            ProductTakeOutRecordModel.fromJson(item);

        recordList.add(recordModel);
      }
    }

    return recordList;
  }

  // Get selected product return record
  static Future<List<ProductReturnRecordModel>>
      get_selected_product_return_record(BuildContext context, Map data) async {
    var map = await send_get_dataToServer(context,
        route: 'get_selected_product_return_record', data: data);
    List<ProductReturnRecordModel> recordList = [];

    if (map != null) {
      List record = map['record'] ?? [];
      for (var item in record) {
        ProductReturnRecordModel recordModel =
            ProductReturnRecordModel.fromJson(item);

        recordList.add(recordModel);
      }
    }

    return recordList;
  }

  // Get selected bad product record
  static Future<List<BadProductRecordModel>> get_selected_bad_product_record(
      BuildContext context, Map data) async {
    var map = await send_get_dataToServer(context,
        route: 'get_selected_bad_product_record', data: data);
    List<BadProductRecordModel> recordList = [];

    if (map != null) {
      List record = map['record'] ?? [];
      for (var item in record) {
        BadProductRecordModel recordModel =
            BadProductRecordModel.fromJson(item);

        recordList.add(recordModel);
      }
    }

    return recordList;
  }

  // Get selected Terminal collection record
  static Future<List<TerminalCollectionRecordModel>>
      get_selected_terminalCollection_record(
          BuildContext context, Map data) async {
    var map = await send_get_dataToServer(context,
        route: 'get_selected_terminalCollection_record', data: data);
    List<TerminalCollectionRecordModel> recordList = [];

    if (map != null) {
      List record = map['record'] ?? [];
      for (var item in record) {
        TerminalCollectionRecordModel recordModel =
            TerminalCollectionRecordModel.fromJson(item);

        recordList.add(recordModel);
      }
    }

    return recordList;
  }

  // Get selected Dangote collection record
  static Future<List<DangoteCollectionRecordModel>>
      get_selected_dangoteCollection_record(
          BuildContext context, Map data) async {
    var map = await send_get_dataToServer(context,
        route: 'get_selected_dangoteCollection_record', data: data);
    List<DangoteCollectionRecordModel> recordList = [];

    if (map != null) {
      List record = map['record'] ?? [];
      for (var item in record) {
        DangoteCollectionRecordModel recordModel =
            DangoteCollectionRecordModel.fromJson(item);

        recordList.add(recordModel);
      }
    }

    return recordList;
  }

  // ! SETTERS

// Add/update products
  static Future<bool> add_update_product(BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'add_update_product', data: data);
  }

// Enter production record
  static Future<bool> enter_production_record(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'enter_production_record', data: data);
  }

// Verify production record
  static Future<bool> verify_production_record(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'verify_production_record', data: data);
  }

// Enter product received record
  static Future<bool> enter_product_received_record(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'enter_product_received_record', data: data);
  }

// Verify product received record
  static Future<bool> verify_product_received_record(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'verify_product_received_record', data: data);
  }

// Enter product request record
  static Future<bool> enter_product_request_record(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'enter_product_request_record', data: data);
  }

// Verify product request record
  static Future<bool> verify_product_request_record(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'verify_product_request_record', data: data);
  }

// Enter product takeOut record
  static Future<bool> enter_product_takeOut_record(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'enter_product_takeOut_record', data: data);
  }

// Verify product takeOut record
  static Future<bool> verify_product_takeOut_record(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'verify_product_takeOut_record', data: data);
  }

// Enter product return record
  static Future<bool> enter_product_return_record(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'enter_product_return_record', data: data);
  }

// Verify product return record
  static Future<bool> verify_product_return_record(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'verify_product_return_record', data: data);
  }

// Enter bad product record
  static Future<bool> enter_bad_product_record(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'enter_bad_product_record', data: data);
  }

// Verify Bad product record
  static Future<bool> verify_bad_product_record(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'verify_bad_product_record', data: data);
  }

// Enter terminal collection record
  static Future<bool> enter_terminalCollection_record(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'enter_terminalCollection_record', data: data);
  }

// Verify terminal collection record
  static Future<bool> verify_terminalCollection_record(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'verify_terminalCollection_record', data: data);
  }

// Enter dangote collection record
  static Future<bool> enter_dangoteCollection_record(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'enter_dangoteCollection_record', data: data);
  }

// Verify dangote collection record
  static Future<bool> verify_dangoteCollection_record(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'verify_dangoteCollection_record', data: data);
  }

// Add/update product category
  static Future<bool> add_update_product_category(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'add_update_product_category', data: data);
  }

// ! REMOVALS

// Delete product
  static Future<bool> delete_product(BuildContext context, String id) async {
    return await deleteFromServer(context, route: 'delete_product', id: id);
  }

// Delete Production record
  static Future<bool> delete_production_record(
      BuildContext context, String id) async {
    return await deleteFromServer(context,
        route: 'delete_production_record', id: id);
  }

// Delete product received record
  static Future<bool> delete_product_received_record(
      BuildContext context, String id) async {
    return await deleteFromServer(context,
        route: 'delete_product_received_record', id: id);
  }

// Delete product request record
  static Future<bool> delete_product_request_record(
      BuildContext context, String id) async {
    return await deleteFromServer(context,
        route: 'delete_product_request_record', id: id);
  }

// Delete product takeOut record
  static Future<bool> delete_product_takeOut_record(
      BuildContext context, String id) async {
    return await deleteFromServer(context,
        route: 'delete_product_takeOut_record', id: id);
  }

  // Delete product return record
  static Future<bool> delete_product_return_record(
      BuildContext context, String id) async {
    return await deleteFromServer(context,
        route: 'delete_product_return_record', id: id);
  }

// Delete Bad product record
  static Future<bool> delete_bad_product_record(
      BuildContext context, String id) async {
    return await deleteFromServer(context,
        route: 'delete_bad_product_record', id: id);
  }

// Delete terminal collection record
  static Future<bool> delete_terminalCollection_record(
      BuildContext context, String id) async {
    return await deleteFromServer(context,
        route: 'delete_terminalCollection_record', id: id);
  }

// Delete dangote collection record
  static Future<bool> delete_dangoteCollection_record(
      BuildContext context, String id) async {
    return await deleteFromServer(context,
        route: 'delete_dangoteCollection_record', id: id);
  }

// Delete product category
  static Future<bool> delete_product_category(
      BuildContext context, String id) async {
    return await deleteFromServer(context,
        route: 'delete_product_category', id: id);
  }

//
}
