class ProductModel {
  String? key;
  String name;
  String code;
  String category;
  int quantity;
  int restockLimit;
  int storePrice;
  int onlinePrice;
  bool isAvailable;
  bool isOnline;
  String? sort;

  ProductModel({
    this.key,
    required this.name,
    required this.code,
    required this.category,
    required this.quantity,
    required this.restockLimit,
    required this.storePrice,
    required this.onlinePrice,
    required this.isAvailable,
    required this.isOnline,
    this.sort,
  });

  // get model from json
  factory ProductModel.fromJson(Map json) {
    return ProductModel(
      key: json['_id'],
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      category: json['category'] ?? '',
      quantity: json['quantity'] ?? 0,
      restockLimit: json['restockLimit'] ?? 0,
      storePrice: json['storePrice'] ?? 0,
      onlinePrice: json['onlinePrice'] ?? 0,
      isAvailable: json['isAvailable'] ?? false,
      isOnline: json['isOnline'] ?? false,
      sort: json['sort'] ?? '0',
    );
  }

  // get json from model
  Map toJson() => {
        'id': key,
        'name': name,
        'code': code,
        'category': category,
        'quantity': quantity,
        'restockLimit': restockLimit,
        'storePrice': storePrice,
        'onlinePrice': onlinePrice,
        'isAvailable': isAvailable,
        'isOnline': isOnline,
      };
}
