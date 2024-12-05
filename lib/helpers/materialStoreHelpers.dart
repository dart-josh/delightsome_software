import 'package:delightsome_software/dataModels/category.model.dart';
import 'package:delightsome_software/dataModels/materialStoreModels/productMaterials.model.dart';
import 'package:delightsome_software/dataModels/materialStoreModels/productMaterialsRequest.model.dart';
import 'package:delightsome_software/dataModels/materialStoreModels/rawMaterials.model.dart';
import 'package:delightsome_software/dataModels/materialStoreModels/rawMaterialsRequest.model.dart';
import 'package:delightsome_software/dataModels/materialStoreModels/restockProductMaterial.model.dart';
import 'package:delightsome_software/dataModels/materialStoreModels/restockRawMaterial.model.dart';
import 'package:delightsome_software/globalvariables.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MaterialStoreHelpers {
  // ! CONSTANTS
  static String materialsStoreUrl = '${server_url}/api/materialstore';

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
    data.addAll({'user': activeStaff!.key!});
    // Json encode data
    var body = jsonEncode(data);

    UniversalHelpers.showLoadingScreen(context: context);
    try {
      var response = await http.post(Uri.parse('${materialsStoreUrl}/${route}'),
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
    if (activeStaff == null) {
      UniversalHelpers.showToast(
        context: context,
        color: Colors.red,
        toastText: 'No User Found',
        icon: Icons.error,
      );
      return {};
    }

    // add current user to data
    data.addAll({'user': activeStaff!.key!});
    // Json encode data
    var body = jsonEncode(data);

    // UniversalHelpers.showLoadingScreen(context: context);
    try {
      var response = await http.post(Uri.parse('${materialsStoreUrl}/${route}'),
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
      var response = await http.delete(
          Uri.parse('${materialsStoreUrl}/${route}/$id'),
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

  // ! GETTERS

// Get product materials
  static Future<List<ProductMaterialsModel>> get_product_materials() async {
    try {
      var response = await http
          .get(Uri.parse('${materialsStoreUrl}/get_product_materials'));

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<ProductMaterialsModel> productMaterialsList = [];
      List items = jsonResponse['items'];
      for (var item in items) {
        ProductMaterialsModel productMaterialsModel =
            ProductMaterialsModel.fromJson(item);

        productMaterialsList.add(productMaterialsModel);
      }

      return productMaterialsList;
    } catch (e) {
      print(e);
      return [];
    }
  }

// Get raw materials
  static Future<List<RawMaterialsModel>> get_raw_materials() async {
    try {
      var response =
          await http.get(Uri.parse('${materialsStoreUrl}/get_raw_materials'));

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<RawMaterialsModel> rawMaterialsList = [];
      List items = jsonResponse['items'];
      for (var item in items) {
        RawMaterialsModel rawMaterialsModel = RawMaterialsModel.fromJson(item);

        rawMaterialsList.add(rawMaterialsModel);
      }

      return rawMaterialsList;
    } catch (e) {
      print(e);
      return [];
    }
  }

// Get Product materials restock record
  static Future<List<RestockProductMaterialModel>>
      get_restock_product_materials_record() async {
    try {
      var response = await http.get(Uri.parse(
          '${materialsStoreUrl}/get_restock_product_materials_record'));

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<RestockProductMaterialModel> recordList = [];
      List record = jsonResponse['record'];

      for (var item in record) {
        RestockProductMaterialModel recordModel =
            RestockProductMaterialModel.fromJson(item);

        recordList.add(recordModel);
      }

      return recordList;
    } catch (e) {
      print(e);
      return [];
    }
  }

// Get raw materials restock record
  static Future<List<RestockRawMaterialModel>>
      get_restock_raw_materials_record() async {
    try {
      var response = await http.get(
          Uri.parse('${materialsStoreUrl}/get_restock_raw_materials_record'));

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<RestockRawMaterialModel> recordList = [];
      List record = jsonResponse['record'];
      for (var item in record) {
        RestockRawMaterialModel recordModel =
            RestockRawMaterialModel.fromJson(item);

        recordList.add(recordModel);
      }

      return recordList;
    } catch (e) {
      print(e);
      return [];
    }
  }

// Get product materials request record
  static Future<List<ProductMaterialsRequestModel>>
      get_product_materials_request_record() async {
    try {
      var response = await http.get(Uri.parse(
          '${materialsStoreUrl}/get_product_materials_request_record'));

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<ProductMaterialsRequestModel> recordList = [];
      List record = jsonResponse['record'];
      for (var item in record) {
        ProductMaterialsRequestModel recordModel =
            ProductMaterialsRequestModel.fromJson(item);

        recordList.add(recordModel);
      }

      return recordList;
    } catch (e) {
      print(e);
      return [];
    }
  }

// Get raw materials request record
  static Future<List<RawMaterialsRequestModel>>
      get_raw_materials_request_record() async {
    try {
      var response = await http.get(
          Uri.parse('${materialsStoreUrl}/get_raw_materials_request_record'));

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResponse['message'];
      }

      List<RawMaterialsRequestModel> recordList = [];
      List record = jsonResponse['record'];
      for (var item in record) {
        RawMaterialsRequestModel recordModel =
            RawMaterialsRequestModel.fromJson(item);

        recordList.add(recordModel);
      }

      return recordList;
    } catch (e) {
      print(e);
      return [];
    }
  }

// Get product materials categories
  static Future<List<CategoryModel>> get_product_materials_categories() async {
    try {
      var response = await http.get(
          Uri.parse('${materialsStoreUrl}/get_product_materials_categories'));

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

// Get raw materials categories
  static Future<List<CategoryModel>> get_raw_materials_categories() async {
    try {
      var response = await http
          .get(Uri.parse('${materialsStoreUrl}/get_raw_materials_categories'));

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

// Get selected product materials request record
  static Future<List<ProductMaterialsRequestModel>>
      get_selected_product_materials_request_record(
          BuildContext context, Map data) async {
    var map = await send_get_dataToServer(context,
        route: 'get_selected_product_materials_request_record', data: data);
    List<ProductMaterialsRequestModel> recordList = [];

    if (map != null) {
      List record = map['record'] ?? [];
      for (var item in record) {
        ProductMaterialsRequestModel recordModel =
            ProductMaterialsRequestModel.fromJson(item);

        recordList.add(recordModel);
      }
    }

    return recordList;
  }

// Get selected product materials request record
  static Future<List<RawMaterialsRequestModel>>
      get_selected_raw_materials_request_record(
          BuildContext context, Map data) async {
    var map = await send_get_dataToServer(context,
        route: 'get_selected_raw_materials_request_record', data: data);
    List<RawMaterialsRequestModel> recordList = [];

    if (map != null) {
      List record = map['record'] ?? [];
      for (var item in record) {
        RawMaterialsRequestModel recordModel =
            RawMaterialsRequestModel.fromJson(item);

        recordList.add(recordModel);
      }
    }

    return recordList;
  }

// Get selected restock product materials record
  static Future<List<RestockProductMaterialModel>>
      get_selected_restock_product_materials_record(
          BuildContext context, Map data) async {
    var map = await send_get_dataToServer(context,
        route: 'get_selected_restock_product_materials_record', data: data);
    List<RestockProductMaterialModel> recordList = [];

    if (map != null) {
      List record = map['record'] ?? [];
      for (var item in record) {
        RestockProductMaterialModel recordModel =
            RestockProductMaterialModel.fromJson(item);

        recordList.add(recordModel);
      }
    }

    return recordList;
  }

// Get selected restock raw materials record
  static Future<List<RestockRawMaterialModel>>
      get_selected_restock_raw_materials_record(
          BuildContext context, Map data) async {
    var map = await send_get_dataToServer(context,
        route: 'get_selected_restock_raw_materials_record', data: data);
    List<RestockRawMaterialModel> recordList = [];

    if (map != null) {
      List record = map['record'] ?? [];
      for (var item in record) {
        RestockRawMaterialModel recordModel =
            RestockRawMaterialModel.fromJson(item);

        recordList.add(recordModel);
      }
    }

    return recordList;
  }

// ! SETTERS

// Add/Update product materials
  static Future<bool> add_update_product_materials(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'add_update_product_materials', data: data);
  }

// Add/Update raw materials
  static Future<bool> add_update_raw_materials(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'add_update_raw_materials', data: data);
  }

// Enter Restock product materials record
  static Future<bool> enter_restock_product_materials_record(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'enter_restock_product_materials_record', data: data);
  }

// Verify Restock product materials record
  static Future<bool> verify_restock_product_materials_record(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'verify_restock_product_materials_record', data: data);
  }

// Enter Restock raw materials record
  static Future<bool> enter_restock_raw_materials_record(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'enter_restock_raw_materials_record', data: data);
  }

// Verify Restock raw product materials record
  static Future<bool> verify_restock_raw_materials_record(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'verify_restock_raw_materials_record', data: data);
  }

// Enter Request for product materials record
  static Future<bool> enter_product_materials_request_record(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'enter_product_materials_request_record', data: data);
  }

// Verify Request for product materials record
  static Future<bool> verify_product_materials_request_record(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'verify_product_materials_request_record', data: data);
  }

// Enter Request for raw materials record
  static Future<bool> enter_raw_materials_request_record(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'enter_raw_materials_request_record', data: data);
  }

// Verify Request for raw materials record
  static Future<bool> verify_raw_materials_request_record(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'verify_raw_materials_request_record', data: data);
  }

// Add/Update product materials categories
  static Future<bool> add_update_product_materials_category(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'add_update_product_materials_category', data: data);
  }

// Add/Update raw materials categories
  static Future<bool> add_update_raw_materials_category(
      BuildContext context, Map data) async {
    return await sendDataToServer(context,
        route: 'add_update_raw_materials_category', data: data);
  }

// ! REMOVALS

// Delete Product materials
  static Future<bool> delete_product_materials(
      BuildContext context, String id) async {
    return await deleteFromServer(context,
        route: 'delete_product_materials', id: id);
  }

// Delete raw materials
  static Future<bool> delete_raw_materials(
      BuildContext context, String id) async {
    return await deleteFromServer(context,
        route: 'delete_raw_materials', id: id);
  }

// Delete restock product materials record
  static Future<bool> delete_restock_product_materials_record(
      BuildContext context, String id) async {
    return await deleteFromServer(context,
        route: 'delete_restock_product_materials_record', id: id);
  }

// Delete restock raw materials record
  static Future<bool> delete_restock_raw_materials_record(
      BuildContext context, String id) async {
    return await deleteFromServer(context,
        route: 'delete_restock_raw_materials_record', id: id);
  }

// Delete product materials request record
  static Future<bool> delete_product_materials_request_record(
      BuildContext context, String id) async {
    return await deleteFromServer(context,
        route: 'delete_product_materials_request_record', id: id);
  }

// Delete raw materials request record
  static Future<bool> delete_raw_materials_request_record(
      BuildContext context, String id) async {
    return await deleteFromServer(context,
        route: 'delete_raw_materials_request_record', id: id);
  }

// Delete product materials categories
  static Future<bool> delete_product_materials_category(
      BuildContext context, String id) async {
    return await deleteFromServer(context,
        route: 'delete_product_materials_category', id: id);
  }

// Delete raw materials categories
  static Future<bool> delete_raw_materials_category(
      BuildContext context, String id) async {
    return await deleteFromServer(context,
        route: 'delete_raw_materials_category', id: id);
  }
}
