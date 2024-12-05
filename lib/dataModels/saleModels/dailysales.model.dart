import 'package:delightsome_software/dataModels/productStoreModels/product.model.dart';

class DailySalesModel {
  String key;
  String date;
  List<DailySalesProductsModel> products;

  DailySalesModel({
    required this.key,
    required this.date,
    required this.products,
  });

  // get model from json
  factory DailySalesModel.fromJson(Map json) {
    return DailySalesModel(
      key: json['_id'],
      date: json['date'] ?? '',
      products: (json['products'] as List)
          .map((x) => DailySalesProductsModel.fromJson(x))
          .toList(),
    );
  }

  // Copy constructor
  DailySalesModel.copy(DailySalesModel other)
      : key = other.key,
        date = other.date,
        products = List<DailySalesProductsModel>.from(
            other.products.map((p) => DailySalesProductsModel.copy(p)));
}

class DailySalesProductsModel {
  String key;
  ProductModel product;
  int storePrice;
  int onlinePrice;
  int openingQuantity;
  int added;
  int request;
  int terminalCollected;
  int terminalReturn;
  int badProduct;
  int online;
  int quantitySold;

  DailySalesProductsModel({
    required this.key,
    required this.product,
    required this.storePrice,
    required this.onlinePrice,
    required this.openingQuantity,
    required this.added,
    required this.request,
    required this.terminalCollected,
    required this.terminalReturn,
    required this.badProduct,
    required this.online,
    required this.quantitySold,
  });

  // get model from json
  factory DailySalesProductsModel.fromJson(Map json) {
    return DailySalesProductsModel(
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
              sort: '',
            ),
      storePrice: json['storePrice'] ?? 0,
      onlinePrice: json['onlinePrice'] ?? 0,
      openingQuantity: json['openingQuantity'] ?? 0,
      added: json['added'] ?? 0,
      request: json['request'] ?? 0,
      terminalCollected: json['terminalCollected'] ?? 0,
      terminalReturn: json['terminalReturn'] ?? 0,
      badProduct: json['badProduct'] ?? 0,
      online: json['online'] ?? 0,
      quantitySold: json['quantitySold'] ?? 0,
    );
  }

  // Copy constructor
  DailySalesProductsModel.copy(DailySalesProductsModel other)
      : key = other.key,
        product = other.product,
        storePrice = other.storePrice,
        onlinePrice = other.onlinePrice,
        openingQuantity = other.openingQuantity,
        added = other.added,
        request = other.request,
        terminalCollected = other.terminalCollected,
        terminalReturn = other.terminalReturn,
        badProduct = other.badProduct,
        online = other.online,
        quantitySold = other.quantitySold;
}
