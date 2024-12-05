class RawMaterialsModel {
  String? key;
  String itemName;
  String category;
  int quantity;
  int restockLimit;
  String measurementUnit;
  String storeType;

  RawMaterialsModel({
    this.key,
    required this.itemName,
    required this.category,
    required this.quantity,
    required this.restockLimit,
    required this.measurementUnit,
    required this.storeType,
  });

  // get model from json
  factory RawMaterialsModel.fromJson(Map json) {
    return RawMaterialsModel(
      key: json['_id'],
      itemName: json['itemName'] ?? '',
      category: json['category'] ?? '',
      quantity: json['quantity'] ?? 0,
      restockLimit: json['restockLimit'] ?? 0,
      measurementUnit: json['measurementUnit'] ?? '',
      storeType: json['storeType'] ?? '',
    );
  }

  // get json from model

  Map toJson() => {
        'id': key,
        'itemName': itemName,
        'category': category,
        'quantity': quantity,
        'restockLimit': restockLimit,
        'measurementUnit': measurementUnit,
        'storeType': storeType,
      };
}
