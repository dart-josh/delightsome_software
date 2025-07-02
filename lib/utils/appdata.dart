import 'package:delightsome_software/dataModels/category.model.dart';

import 'package:delightsome_software/dataModels/materialStoreModels/productMaterials.model.dart';
import 'package:delightsome_software/dataModels/materialStoreModels/productMaterialsRequest.model.dart';
import 'package:delightsome_software/dataModels/materialStoreModels/productMaterialsReturn.model.dart';
import 'package:delightsome_software/dataModels/materialStoreModels/rawMaterials.model.dart';
import 'package:delightsome_software/dataModels/materialStoreModels/rawMaterialsRequest.model.dart';
import 'package:delightsome_software/dataModels/materialStoreModels/restockProductMaterial.model.dart';
import 'package:delightsome_software/dataModels/materialStoreModels/restockRawMaterial.model.dart';

import 'package:delightsome_software/dataModels/productStoreModels/badProductRecord.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/dangoteCollectionRecord.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/product.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/productReceivedRecord.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/productRequestRecord.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/productReturnRecord.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/productTakeOutRecord.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/productionRecord.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/terminalCollectionRecord.model.dart';

import 'package:delightsome_software/dataModels/saleModels/dailysales.model.dart';
import 'package:delightsome_software/dataModels/saleModels/dangoteDailysales.model.dart';
import 'package:delightsome_software/dataModels/saleModels/sales.model.dart';
import 'package:delightsome_software/dataModels/saleModels/shop.model.dart';
import 'package:delightsome_software/dataModels/saleModels/terminalDailysales.model.dart';

import 'package:delightsome_software/dataModels/userModels/customer.model.dart';
import 'package:delightsome_software/dataModels/userModels/staff.model.dart';

import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  // ! APP DEFAULTS

  bool can_refresh = false;
  bool can_logout = false;

  // theme
  ThemeMode themeMode = ThemeMode.system;
  bool drawer_expanded = false;

  // variables
  List<ShopModel> outlet_shops = [];
  List<ShopModel> terminal_shops = [];
  List<ShopModel> dangote_shops = [];

  // ! Material Store

  List<ProductMaterialsModel> product_material_list = [];
  List<RawMaterialsModel> raw_material_list = [];

  List<RestockProductMaterialModel> restock_product_material_record = [];
  List<RestockRawMaterialModel> restock_raw_material_record = [];

  List<ProductMaterialsRequestModel> product_material_request_record = [];
  List<RawMaterialsRequestModel> raw_material_request_record = [];

  List<ProductMaterialsReturnModel> product_material_return_record = [];

  List<CategoryModel> product_material_categories = [];
  List<CategoryModel> raw_material_categories = [];

  // ! Product Store
  List<ProductModel> product_list = [];
  List<ProductModel> terminal_product_list = [];
  List<ProductModel> dangote_product_list = [];

  List<ProductionRecordModel> production_record = [];
  List<ProductReceivedRecordModel> product_received_record = [];
  List<ProductRequestRecordModel> product_request_record = [];
  List<ProductTakeOutRecordModel> product_takeOut_record = [];
  List<ProductReturnRecordModel> product_return_record = [];
  List<BadProductRecordModel> bad_product_record = [];
  List<TerminalCollectionRecordModel> terminal_collection_record = [];
  List<DangoteCollectionRecordModel> dangote_collection_record = [];

  List<CategoryModel> product_categories = [];

  // ! Sales

  List<SalesModel> sales_record = [];
  List<SalesModel> terminal_sales_record = [];
  List<SalesModel> dangote_sales_record = [];

  List<DailySalesModel> daily_sales_record = [];
  List<TerminalDailySalesModel> terminal_daily_sales_record = [];
  List<DangoteDailySalesModel> dangote_daily_sales_record = [];

  // ! Users

  List<StaffModel> staff_list = [];
  List<CustomerModel> customer_list = [];

  StaffModel? active_staff;

  // SETTERS

  // ! APP DEFAULTS
  void update_can_refresh(bool value) {
    can_refresh = value;
    notifyListeners();
  }

  void update_can_logout(bool value) {
    can_logout = value;
    notifyListeners();
  }

  void update_themeMode(ThemeMode value) {
    themeMode = value;
    notifyListeners();
  }

  void set_drawer_expanded(bool value) {
    drawer_expanded = value;
    notifyListeners();
  }

  void toggle_drawer_expanded() {
    drawer_expanded = !drawer_expanded;
    notifyListeners();
  }

  void new_outlet_shop(ShopModel value) {
    outlet_shops.add(value);
    notifyListeners();
  }

  void update_outlet_shop(ShopModel value) {
    var index = outlet_shops.indexWhere((e) => e.key == value.key);
    if (index != -1) {
      outlet_shops[index] = value;
    }

    notifyListeners();
  }

  void delete_outlet_shop(ShopModel value) {
    outlet_shops.remove(value);

    notifyListeners();
  }

  void new_terminal_shop(ShopModel value) {
    terminal_shops.add(value);
    notifyListeners();
  }

  void update_terminal_shop(ShopModel value) {
    var index = terminal_shops.indexWhere((e) => e.key == value.key);
    if (index != -1) {
      terminal_shops[index] = value;
    }

    notifyListeners();
  }

  void delete_terminal_shop(ShopModel value) {
    terminal_shops.remove(value);

    notifyListeners();
  }

  void new_dangote_shop(ShopModel value) {
    dangote_shops.add(value);
    notifyListeners();
  }

  void update_dangote_shop(ShopModel value) {
    var index = dangote_shops.indexWhere((e) => e.key == value.key);
    if (index != -1) {
      dangote_shops[index] = value;
    }

    notifyListeners();
  }

  void delete_dangote_shop(ShopModel value) {
    dangote_shops.remove(value);

    notifyListeners();
  }

  // ! Material Store

  // product_material_list
  void update_product_material_list(List<ProductMaterialsModel> value) {
    product_material_list = value;
    notifyListeners();
  }

  // raw_material_list
  void update_raw_material_list(List<RawMaterialsModel> value) {
    raw_material_list = value;
    notifyListeners();
  }

  // restock_product_material_record
  void update_restock_product_material_record(
      List<RestockProductMaterialModel> value) {
    restock_product_material_record = value;
    notifyListeners();
  }

  // restock_raw_material_record
  void update_restock_raw_material_record(List<RestockRawMaterialModel> value) {
    restock_raw_material_record = value;
    notifyListeners();
  }

  // product_material_request_record
  void update_product_material_request_record(
      List<ProductMaterialsRequestModel> value) {
    product_material_request_record = value;
    notifyListeners();
  }

  // raw_material_request_record
  void update_raw_material_request_record(
      List<RawMaterialsRequestModel> value) {
    raw_material_request_record = value;
    notifyListeners();
  }

  // product_material_return_record
  void update_product_material_return_record(
      List<ProductMaterialsReturnModel> value) {
    product_material_return_record = value;
    notifyListeners();
  }

  // product_material_categories
  void update_product_material_categories(List<CategoryModel> value) {
    product_material_categories = value;
    notifyListeners();
  }

  // raw_material_categories
  void update_raw_material_categories(List<CategoryModel> value) {
    raw_material_categories = value;
    notifyListeners();
  }

  // ! Product Store
  // product_list
  void update_product_list(List<ProductModel> value) {
    product_list = value;
    notifyListeners();
  }

  // terminal_product_list
  void update_terminal_product_list(List<ProductModel> value) {
    terminal_product_list = value;
    notifyListeners();
  }

  // dangote_product_list
  void update_dangote_product_list(List<ProductModel> value) {
    dangote_product_list = value;
    notifyListeners();
  }

  // production_record
  void update_production_record(List<ProductionRecordModel> value) {
    production_record = value;
    notifyListeners();
  }

  // product_received_record
  void update_product_received_record(List<ProductReceivedRecordModel> value) {
    product_received_record = value;
    notifyListeners();
  }

  // product_request_record
  void update_product_request_record(List<ProductRequestRecordModel> value) {
    product_request_record = value;
    notifyListeners();
  }

  // product_takeOut_record
  void update_product_takeOut_record(List<ProductTakeOutRecordModel> value) {
    product_takeOut_record = value;
    notifyListeners();
  }

  // product_return_record
  void update_product_return_record(List<ProductReturnRecordModel> value) {
    product_return_record = value;
    notifyListeners();
  }

  // bad_product_record
  void update_bad_product_record(List<BadProductRecordModel> value) {
    bad_product_record = value;
    notifyListeners();
  }

  // terminal_collection_record
  void update_terminal_collection_record(
      List<TerminalCollectionRecordModel> value) {
    terminal_collection_record = value;
    notifyListeners();
  }

  // dangote_collection_record
  void update_dangote_collection_record(
      List<DangoteCollectionRecordModel> value) {
    dangote_collection_record = value;
    notifyListeners();
  }

  // product_categories
  void update_product_categories(List<CategoryModel> value) {
    product_categories = value;
    notifyListeners();
  }

  // ! Sales

  // sales_record
  void update_sales_record(List<SalesModel> value) {
    sales_record = value;
    notifyListeners();
  }

  // terminal_sales_record
  void update_terminal_sales_record(List<SalesModel> value) {
    terminal_sales_record = value;
    notifyListeners();
  }

  // dangote_sales_record
  void update_dangote_sales_record(List<SalesModel> value) {
    dangote_sales_record = value;
    notifyListeners();
  }

  // daily_sales_record
  void update_daily_sales_record(List<DailySalesModel> value) {
    daily_sales_record = value;
    notifyListeners();
  }

  // terminal_daily_sales_record
  void update_terminal_daily_sales_record(List<TerminalDailySalesModel> value) {
    terminal_daily_sales_record = value;
    notifyListeners();
  }

  // dangote_daily_sales_record
  void update_dangote_daily_sales_record(List<DangoteDailySalesModel> value) {
    dangote_daily_sales_record = value;
    notifyListeners();
  }

  // ! Users

  // staff_list
  void update_staff_list(List<StaffModel> value) {
    staff_list = value;
    notifyListeners();
  }

  // customer_list
  void update_customer_list(List<CustomerModel> value) {
    customer_list = value;
    notifyListeners();
  }

  // update active staff
  void update_active_staff(StaffModel? value) {
    active_staff = value;
    notifyListeners();
  }

  //
}
