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
    var rec = await MaterialStoreHelpers.get_product_materials(context);

    Provider.of<AppData>(context, listen: false)
        .update_product_material_list(rec);
  }

  // get raw materials
  static get_raw_materials(context) async {
    var rec = await MaterialStoreHelpers.get_raw_materials(context);

    Provider.of<AppData>(context, listen: false).update_raw_material_list(rec);
  }

  // get restock product materials record
  static get_restock_product_materials_record(context) async {
    var rec = await MaterialStoreHelpers.get_restock_product_materials_record(
        context);

    Provider.of<AppData>(context, listen: false)
        .update_restock_product_material_record(rec);
  }

  // get restock raw materials record
  static get_restock_raw_materials_record(context) async {
    var rec =
        await MaterialStoreHelpers.get_restock_raw_materials_record(context);

    Provider.of<AppData>(context, listen: false)
        .update_restock_raw_material_record(rec);
  }

  // get product materials request record
  static get_product_materials_request_record(context) async {
    var rec = await MaterialStoreHelpers.get_product_materials_request_record(
        context);

    Provider.of<AppData>(context, listen: false)
        .update_product_material_request_record(rec);
  }

  // get raw materials request record
  static get_raw_materials_request_record(context) async {
    var rec =
        await MaterialStoreHelpers.get_raw_materials_request_record(context);

    Provider.of<AppData>(context, listen: false)
        .update_raw_material_request_record(rec);
  }

  // get product materials return record
  static get_product_materials_return_record(context) async {
    var rec =
        await MaterialStoreHelpers.get_product_materials_return_record(context);

    Provider.of<AppData>(context, listen: false)
        .update_product_material_return_record(rec);
  }

  // get product materials category
  static get_product_materials_categories(context) async {
    var rec =
        await MaterialStoreHelpers.get_product_materials_categories(context);

    Provider.of<AppData>(context, listen: false)
        .update_product_material_categories(rec);
  }

  // get raw materials category
  static get_raw_materials_categories(context) async {
    var rec = await MaterialStoreHelpers.get_raw_materials_categories(context);

    Provider.of<AppData>(context, listen: false)
        .update_raw_material_categories(rec);
  }

  // ? PRODUCTS STORE

  // Get all products
  static get_products(context) async {
    var rec = await ProductStoreHelpers.get_products(context);

    Provider.of<AppData>(context, listen: false).update_product_list(rec);
  }

  // get outlet products
  static get_outlet_products(context) async {
    var rec = await ProductStoreHelpers.get_outlet_products(context);

    Provider.of<AppData>(context, listen: false)
        .update_outlet_product_list(rec);
  }

  // get terminal products
  static get_terminal_products(context) async {
    var rec = await ProductStoreHelpers.get_terminal_products(context);

    Provider.of<AppData>(context, listen: false)
        .update_terminal_product_list(rec);
  }

  // get dangote products
  static get_dangote_products(context) async {
    var rec = await ProductStoreHelpers.get_dangote_products(context);

    Provider.of<AppData>(context, listen: false)
        .update_dangote_product_list(rec);
  }

  //?

  // get production record
  static get_production_record(context) async {
    var rec = await ProductStoreHelpers.get_production_record(context);

    Provider.of<AppData>(context, listen: false).update_production_record(rec);
  }

  // Get product received record
  static get_product_received_record(context) async {
    var rec = await ProductStoreHelpers.get_product_received_record(context);

    Provider.of<AppData>(context, listen: false)
        .update_product_received_record(rec);
  }

  // Get product request record
  static get_product_request_record(context) async {
    var rec = await ProductStoreHelpers.get_product_request_record(context);

    Provider.of<AppData>(context, listen: false)
        .update_product_request_record(rec);
  }

  // Get product takeOut record
  static get_product_takeOut_record(context) async {
    var rec = await ProductStoreHelpers.get_product_takeOut_record(context);

    Provider.of<AppData>(context, listen: false)
        .update_product_takeOut_record(rec);
  }

  // Get product return record
  static get_product_return_record(context) async {
    var rec = await ProductStoreHelpers.get_product_return_record(context);

    Provider.of<AppData>(context, listen: false)
        .update_product_return_record(rec);
  }

  // Get bad product record
  static get_bad_product_record(context) async {
    var rec = await ProductStoreHelpers.get_bad_product_record(context);

    Provider.of<AppData>(context, listen: false).update_bad_product_record(rec);
  }

  // Get Outlet collection record
  static get_outletCollection_record(context) async {
    var rec = await ProductStoreHelpers.get_outletCollection_record(context);

    Provider.of<AppData>(context, listen: false)
        .update_outlet_collection_record(rec);
  }

  // Get Terminal collection record
  static get_terminalCollection_record(context) async {
    var rec = await ProductStoreHelpers.get_terminalCollection_record(context);

    Provider.of<AppData>(context, listen: false)
        .update_terminal_collection_record(rec);
  }

  // Get Dangote collection record
  static get_dangoteCollection_record(context) async {
    var rec = await ProductStoreHelpers.get_dangoteCollection_record(context);

    Provider.of<AppData>(context, listen: false)
        .update_dangote_collection_record(rec);
  }

  //?

  // get product categories
  static get_product_categories(context) async {
    var rec = await ProductStoreHelpers.get_product_categories(context);

    Provider.of<AppData>(context, listen: false).update_product_categories(rec);
  }

  // ? SALES
  // get store sales record
  static get_store_sales_record(context) async {
    var rec = await SaleHelpers.get_store_sales_record(context);

    Provider.of<AppData>(context, listen: false).update_store_sales_record(rec);
  }

  // get daily sales record
  static get_daily_store_record(context) async {
    var rec = await SaleHelpers.get_daily_store_record(context);

    Provider.of<AppData>(context, listen: false).update_daily_store_record(rec);
  }

  // get outlet_sales record
  static get_outlet_sales_record(context) async {
    var rec = await SaleHelpers.get_outlet_sales_record(context);

    Provider.of<AppData>(context, listen: false)
        .update_outlet_sales_record(rec);
  }

  // get outlet daily sales record
  static get_outlet_daily_sales_record(context) async {
    var rec = await SaleHelpers.get_outlet_daily_sales_record(context);

    Provider.of<AppData>(context, listen: false)
        .update_outlet_daily_sales_record(rec);
  }

  // get terminal_sales record
  static get_terminal_sales_record(context) async {
    var rec = await SaleHelpers.get_terminal_sales_record(context);

    Provider.of<AppData>(context, listen: false)
        .update_terminal_sales_record(rec);
  }

  // get terminal daily sales record
  static get_terminal_daily_sales_record(context) async {
    var rec = await SaleHelpers.get_terminal_daily_sales_record(context);

    Provider.of<AppData>(context, listen: false)
        .update_terminal_daily_sales_record(rec);
  }

  // get dangote_sales record
  static get_dangote_sales_record(context) async {
    var rec = await SaleHelpers.get_dangote_sales_record(context);

    Provider.of<AppData>(context, listen: false)
        .update_dangote_sales_record(rec);
  }

  // get dangote daily sales record
  static get_dangote_daily_sales_record(context) async {
    var rec = await SaleHelpers.get_dangote_daily_sales_record(context);

    Provider.of<AppData>(context, listen: false)
        .update_dangote_daily_sales_record(rec);
  }

  // ? USER

  // todo get_all_staff
  static get_all_staff(context) async {
    var rec = await UserHelpers.get_all_staff(context);

    Provider.of<AppData>(context, listen: false).update_staff_list(rec);
  }

  // get customer
  static get_all_customer(context) async {
    var rec = await UserHelpers.get_all_customer(context);

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
