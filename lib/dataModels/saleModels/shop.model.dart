import 'package:delightsome_software/dataModels/productStoreModels/productItem.model.dart';
import 'package:delightsome_software/dataModels/userModels/customer.model.dart';
import 'package:delightsome_software/pages/salePages/print.page.dart';
import 'package:flutter/material.dart';

class ShopModel {
  String key;
  CustomerModel? customer;
  List<ProductItemModel> products;
  bool is_online;
  bool isExpanded;
  bool done;
  Offset position;
  PrintModel? printModel;
  String? orderId;

  ShopModel({
    required this.key,
    required this.customer,
    required this.products,
    this.is_online = false,
    this.isExpanded = true,
    this.done = false,
    required this.position,
    this.printModel,
    this.orderId,
  });
}
