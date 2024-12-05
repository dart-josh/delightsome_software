import 'package:delightsome_software/dataModels/productStoreModels/product.model.dart';

class TerminalDailySalesModel {
  String key;
  String date;
  List<TerminalDailySalesProductsModel> products;

  TerminalDailySalesModel({
    required this.key,
    required this.date,
    required this.products,
  });

  // get model from json
  factory TerminalDailySalesModel.fromJson(Map json) {
    return TerminalDailySalesModel(
      key: json['_id'],
      date: json['date'],
      products: (json['products'] as List)
          .map((x) => TerminalDailySalesProductsModel.fromJson(x))
          .toList(),
    );
  }

  // Copy constructor
  TerminalDailySalesModel.copy(TerminalDailySalesModel other)
      : key = other.key,
        date = other.date,
        products = List<TerminalDailySalesProductsModel>.from(
            other.products.map((p) => TerminalDailySalesProductsModel.copy(p)));
}

class TerminalDailySalesProductsModel {
  String key;
  ProductModel product;
  int storePrice;
  int openingQuantity;
  int collected;
  int returned;
  int sold;

  TerminalDailySalesProductsModel({
    required this.key,
    required this.product,
    required this.storePrice,
    required this.openingQuantity,
    required this.collected,
    required this.returned,
    required this.sold,
  });

  // get model from json
  factory TerminalDailySalesProductsModel.fromJson(Map json) {
    return TerminalDailySalesProductsModel(
      key: json['_id'],
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : ProductModel(
            key: 'null',
              name: 'Deleted',
              code: '',
              category: '',
              quantity: 0,
              restockLimit: 0,
              storePrice: 0,
              onlinePrice: 0,
              isAvailable: false,
              isOnline: false,
            ),
      storePrice: json['storePrice'] ?? 0,
      openingQuantity: json['openingQuantity'] ?? 0,
      collected: json['collected'] ?? 0,
      returned: json['returned'] ?? 0,
      sold: json['sold'] ?? 0,
    );
  }

  // Copy constructor
  TerminalDailySalesProductsModel.copy(TerminalDailySalesProductsModel other)
      : key = other.key,
        product = other.product,
        storePrice = other.storePrice,
        openingQuantity = other.openingQuantity,
        collected = other.collected,
        returned = other.returned,
        sold = other.sold;
}
