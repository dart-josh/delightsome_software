import 'package:delightsome_software/dataModels/productStoreModels/productItem.model.dart';
import 'package:delightsome_software/dataModels/userModels/customer.model.dart';
import 'package:delightsome_software/dataModels/saleModels/paymentMethod.model.dart';
import 'package:delightsome_software/dataModels/userModels/staff.model.dart';

class SalesModel {
  String? key;
  DateTime? recordDate;
  String? orderId;
  List<ProductItemModel> products;
  int orderPrice;
  int? totalQuantity;
  CustomerModel? customer;
  String? shortNote;
  String paymentMethod;
  List<PaymentMethodModel>? splitPaymentMethod;
  int? discountPrice;
  StaffModel? soldBy;
  String saleType;
  DateTime? createdAt;

  SalesModel({
    this.key,
    this.recordDate,
    this.orderId,
    required this.products,
    required this.orderPrice,
    this.totalQuantity,
    this.customer,
    this.shortNote,
    required this.paymentMethod,
    this.splitPaymentMethod,
    this.discountPrice,
    this.soldBy,
    required this.saleType,
    this.createdAt,
  });

  // get model from json
  factory SalesModel.fromJson(Map json) {
    return SalesModel(
      key: json['_id'],
      recordDate: (json['recordDate'] != null)
          ? DateTime.parse(json['recordDate'])
          : null,
      orderId: json['orderId'] ?? null,
      products: (json['products'] as List)
          .map((x) => ProductItemModel.fromJson(x))
          .toList(),
      orderPrice: json['orderPrice'] ?? 0,
      totalQuantity: json['totalQuantity'] ?? 0,
      customer: json['customer'] != null
          ? CustomerModel.fromJson(json['customer'])
          : null,
      shortNote: json['shortNote'] ?? null,
      paymentMethod: json['paymentMethod'] ?? '',
      splitPaymentMethod: (json['splitPaymentMethod'] as List)
          .map((x) => PaymentMethodModel.fromJson(x))
          .toList(),
      discountPrice: json['discountPrice'] ?? 0,
      soldBy:
          json['soldBy'] != null ? StaffModel.fromJson(json['soldBy']) : null,
      saleType: json['saleType'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // get json from model
  Map toJson({required String soldBy}) => {
        'products': products.map((x) => x.toJson()).toList(),
        'orderPrice': orderPrice,
        'customer': customer?.key ?? null,
        'shortNote': shortNote,
        'paymentMethod': paymentMethod,
        'splitPaymentMethod':
            splitPaymentMethod?.map((x) => x.toJson()).toList(),
        'discountPrice': discountPrice,
        'soldBy': soldBy,
        'saleType': saleType,
        'date': recordDate?.toIso8601String(),
      };

  SalesModel.copy(SalesModel other)
      : key = other.key,
        recordDate = other.recordDate,
        orderId = other.orderId,
        products = other.products,
        orderPrice = other.orderPrice,
        totalQuantity = other.totalQuantity,
        customer = other.customer,
        shortNote = other.shortNote,
        paymentMethod = other.paymentMethod,
        splitPaymentMethod = other.splitPaymentMethod,
        discountPrice = other.discountPrice,
        soldBy = other.soldBy,
        saleType = other.saleType,
        createdAt = other.createdAt;
}
