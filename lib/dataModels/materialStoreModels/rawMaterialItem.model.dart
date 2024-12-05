import 'package:delightsome_software/dataModels/materialStoreModels/rawMaterials.model.dart';

class RawMaterialItemModel {
  String? key;
  RawMaterialsModel item;
  int quantity;

  RawMaterialItemModel({
    this.key,
    required this.item,
    required this.quantity,
  });

  // get model from json
  factory RawMaterialItemModel.fromJson(Map json) {
    return RawMaterialItemModel(
      key: json['_id'],
      item: json['item'] != null
          ? RawMaterialsModel.fromJson(json['item'])
          : RawMaterialsModel(
              itemName: 'Deleted',
              category: '',
              quantity: 0,
              restockLimit: 0,
              measurementUnit: '',
              storeType: '',
            ),
      quantity: json['quantity'],
    );
  }

  // get json from model
  Map toJson() => {
        'item': item.key,
        'quantity': quantity,
      };
}
