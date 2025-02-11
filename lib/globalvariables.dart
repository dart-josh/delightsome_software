import 'package:delightsome_software/dataModels/materialStoreModels/productMaterialsRequest.model.dart';
import 'package:delightsome_software/dataModels/materialStoreModels/productMaterialsReturn.model.dart';
import 'package:delightsome_software/dataModels/materialStoreModels/rawMaterialsRequest.model.dart';
import 'package:delightsome_software/dataModels/materialStoreModels/restockProductMaterial.model.dart';
import 'package:delightsome_software/dataModels/materialStoreModels/restockRawMaterial.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/badProductRecord.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/productReceivedRecord.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/productRequestRecord.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/productionRecord.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/terminalCollectionRecord.model.dart';
import 'package:flutter/material.dart';

String server_url = 'http://192.168.0.111:5000';

//? APP RESTART
final ValueNotifier<UniqueKey> appRestartNotifier = ValueNotifier(UniqueKey());

//? SAVED RECORDS
ProductMaterialsRequestModel? saved_product_material_request_model;
RawMaterialsRequestModel? saved_raw_material_request_model;
ProductMaterialsReturnModel? saved_product_material_return_model;
RestockProductMaterialModel? saved_restock_product_material_model;
RestockRawMaterialModel? saved_restock_raw_material_model;

BadProductRecordModel? saved_bad_product_model;
ProductReceivedRecordModel? saved_product_received_model;
ProductRequestRecordModel? saved_product_request_model;
ProductionRecordModel? saved_production_model;
TerminalCollectionRecordModel? saved_terminal_collected_model;
TerminalCollectionRecordModel? saved_terminal_returned_model;

// category type
List<String> category_type_list = [
  'Product Material Store',
  'Raw Material Store',
  'Product Store'
];


// ? Home Defaults
bool inventories_expanded = true;
bool shops_expanded = true;
bool product_store_forms_expanded = true;
bool material_store_expanded = true;
bool summaries_expanded = true;
bool utilities_expanded = true;

// String current_version = '1.6.6';
