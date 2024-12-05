class ProductMaterialsModel {
  String? key;
  String itemName;
  String category;
  int quantity;
  int restockLimit;

  ProductMaterialsModel({
    this.key,
    required this.itemName,
    required this.category,
    required this.quantity,
    required this.restockLimit,
  });

  // get model from json
  factory ProductMaterialsModel.fromJson(Map json) => ProductMaterialsModel(
        key: json['_id'],
        itemName: json['itemName'] ?? '',
        category: json['category'] ?? '',
        quantity: json['quantity'] ?? 0,
        restockLimit: json['restockLimit'] ?? 0,
      );

  // get json from model
  Map toJson() => {
        'id': key,
        'itemName': itemName,
        'category': category,
        'quantity': quantity,
        'restockLimit': restockLimit,
      };
}

