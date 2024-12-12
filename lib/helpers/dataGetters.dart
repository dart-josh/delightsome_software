
import 'package:delightsome_software/helpers/authHelpers.dart';
import 'package:delightsome_software/helpers/materialStoreHelpers.dart';
import 'package:delightsome_software/helpers/productStoreHelpers.dart';
import 'package:delightsome_software/helpers/saleHelpers.dart';
import 'package:delightsome_software/helpers/userHelpers.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:provider/provider.dart';

class DataGetters {
  // ? MATERIALS STORE

  // get product materials
  static get_product_materials(context) async {
    var rec = await MaterialStoreHelpers.get_product_materials();

    Provider.of<AppData>(context, listen: false)
        .update_product_material_list(rec);
  }

  // get raw materials
  static get_raw_materials(context) async {
    var rec = await MaterialStoreHelpers.get_raw_materials();

    Provider.of<AppData>(context, listen: false).update_raw_material_list(rec);
  }

  // get restock product materials record
  static get_restock_product_materials_record(context) async {
    var rec = await MaterialStoreHelpers.get_restock_product_materials_record();

    Provider.of<AppData>(context, listen: false)
        .update_restock_product_material_record(rec);
  }

  // get restock raw materials record
  static get_restock_raw_materials_record(context) async {
    var rec = await MaterialStoreHelpers.get_restock_raw_materials_record();

    Provider.of<AppData>(context, listen: false)
        .update_restock_raw_material_record(rec);
  }

  // get product materials request record
  static get_product_materials_request_record(context) async {
    var rec = await MaterialStoreHelpers.get_product_materials_request_record();

    Provider.of<AppData>(context, listen: false)
        .update_product_material_request_record(rec);
  }

  // get raw materials request record
  static get_raw_materials_request_record(context) async {
    var rec = await MaterialStoreHelpers.get_raw_materials_request_record();

    Provider.of<AppData>(context, listen: false)
        .update_raw_material_request_record(rec);
  }

  // get product materials category
  static get_product_materials_categories(context) async {
    var rec = await MaterialStoreHelpers.get_product_materials_categories();

    Provider.of<AppData>(context, listen: false)
        .update_product_material_categories(rec);
  }

  // get raw materials category
  static get_raw_materials_categories(context) async {
    var rec = await MaterialStoreHelpers.get_raw_materials_categories();

    Provider.of<AppData>(context, listen: false)
        .update_raw_material_categories(rec);
  }

  // ? PRODUCTS STORE

  // Get all products
  static get_products(context) async {
    var rec = await ProductStoreHelpers.get_products();

    Provider.of<AppData>(context, listen: false).update_product_list(rec);
  }

  // get terminal products
  static get_terminal_products(context) async {
    var rec = await ProductStoreHelpers.get_terminal_products();

    Provider.of<AppData>(context, listen: false)
        .update_terminal_product_list(rec);
  }

  // get production record
  static get_production_record(context) async {
    var rec = await ProductStoreHelpers.get_production_record();

    Provider.of<AppData>(context, listen: false).update_production_record(rec);
  }

  // Get product received record
  static get_product_received_record(context) async {
    var rec = await ProductStoreHelpers.get_product_received_record();

    Provider.of<AppData>(context, listen: false)
        .update_product_received_record(rec);
  }

  // Get product request record
  static get_product_request_record(context) async {
    var rec = await ProductStoreHelpers.get_product_request_record();

    Provider.of<AppData>(context, listen: false)
        .update_product_request_record(rec);
  }

  // Get bad product record
  static get_bad_product_record(context) async {
    var rec = await ProductStoreHelpers.get_bad_product_record();

    Provider.of<AppData>(context, listen: false).update_bad_product_record(rec);
  }

  // Get Terminal collection record
  static get_terminalCollection_record(context) async {
    var rec = await ProductStoreHelpers.get_terminalCollection_record();

    Provider.of<AppData>(context, listen: false)
        .update_terminal_collection_record(rec);
  }

  // get product categories
  static get_product_categories(context) async {
    var rec = await ProductStoreHelpers.get_product_categories();

    Provider.of<AppData>(context, listen: false).update_product_categories(rec);
  }

  // ? SALES
  // get sales record
  static get_sales_record(context) async {
    var rec = await SaleHelpers.get_sales_record();

    Provider.of<AppData>(context, listen: false).update_sales_record(rec);
  }

  // get daily sales record
  static get_daily_sales_record(context) async {
    var rec = await SaleHelpers.get_daily_sales_record();

    Provider.of<AppData>(context, listen: false).update_daily_sales_record(rec);
  }

  // get terminal_sales record
  static get_terminal_sales_record(context) async {
    var rec = await SaleHelpers.get_terminal_sales_record();

    Provider.of<AppData>(context, listen: false)
        .update_terminal_sales_record(rec);
  }

  // get terminal daily sales record
  static get_terminal_daily_sales_record(context) async {
    var rec = await SaleHelpers.get_terminal_daily_sales_record();

    Provider.of<AppData>(context, listen: false)
        .update_terminal_daily_sales_record(rec);
  }

  // ? USER

  // todo get_all_staff
  static get_all_staff(context) async {
    var rec = await UserHelpers.get_all_staff();

    Provider.of<AppData>(context, listen: false).update_staff_list(rec);
  }

  // get customer
  static get_all_customer(context) async {
    var rec = await UserHelpers.get_all_customer();

    Provider.of<AppData>(context, listen: false).update_customer_list(rec);
  }

  // get active staff
  static get_active_staff(context, String staff_id) async {
    var staff = await AuthHelpers.get_active_staff(staff_id);

    Provider.of<AppData>(context, listen: false).update_active_staff(staff);
    return staff;
  }

  //
}
