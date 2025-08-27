import 'package:delightsome_software/dataModels/productStoreModels/product.model.dart';

class DailyStoreModel {
  String key;
  String date;
  List<DailyStoreProductsModel> products;

  DailyStoreModel({
    required this.key,
    required this.date,
    required this.products,
  });

  // get model from json
  factory DailyStoreModel.fromJson(Map json) {
    return DailyStoreModel(
      key: json['_id'],
      date: json['date'] ?? '',
      products: (json['products'] as List)
          .map((x) => DailyStoreProductsModel.fromJson(x))
          .toList(),
    );
  }

  // Copy constructor
  DailyStoreModel.copy(DailyStoreModel other)
      : key = other.key,
        date = other.date,
        products = List<DailyStoreProductsModel>.from(
            other.products.map((p) => DailyStoreProductsModel.copy(p)));
}

class DailyStoreProductsModel {
  String key;
  ProductModel product;
  int storePrice;
  int onlinePrice;
  int openingQuantity;
  int added;
  int request;
  int takeOut;
  int returnn;
  int outletCollected;
  int outletReturn;
  int terminalCollected;
  int terminalReturn;
  int dangoteCollected;
  int dangoteReturn;
  int badProduct;
  int online;
  int quantitySold;

  DailyStoreProductsModel({
    required this.key,
    required this.product,
    required this.storePrice,
    required this.onlinePrice,
    required this.openingQuantity,
    required this.added,
    required this.request,
    required this.takeOut,
    required this.returnn,
    required this.outletCollected,
    required this.outletReturn,
    required this.terminalCollected,
    required this.terminalReturn,
    required this.dangoteCollected,
    required this.dangoteReturn,
    required this.badProduct,
    required this.online,
    required this.quantitySold,
  });

  // get model from json
  factory DailyStoreProductsModel.fromJson(Map json) {
    return DailyStoreProductsModel(
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
      takeOut: json['takeOut'] ?? 0,
      returnn: json['return'] ?? 0,
      outletCollected: json['outletCollected'] ?? 0,
      outletReturn: json['outletReturn'] ?? 0,
      terminalCollected: json['terminalCollected'] ?? 0,
      terminalReturn: json['terminalReturn'] ?? 0,
      dangoteCollected: json['dangoteCollected'] ?? 0,
      dangoteReturn: json['dangoteReturn'] ?? 0,
      badProduct: json['badProduct'] ?? 0,
      online: json['online'] ?? 0,
      quantitySold: json['quantitySold'] ?? 0,
    );
  }

  // Copy constructor
  DailyStoreProductsModel.copy(DailyStoreProductsModel other)
      : key = other.key,
        product = other.product,
        storePrice = other.storePrice,
        onlinePrice = other.onlinePrice,
        openingQuantity = other.openingQuantity,
        added = other.added,
        request = other.request,
        takeOut = other.takeOut,
        returnn = other.returnn,
        outletCollected = other.outletCollected,
        outletReturn = other.outletReturn,
        terminalCollected = other.terminalCollected,
        terminalReturn = other.terminalReturn,
        dangoteCollected = other.dangoteCollected,
        dangoteReturn = other.dangoteReturn,
        badProduct = other.badProduct,
        online = other.online,
        quantitySold = other.quantitySold;
}
