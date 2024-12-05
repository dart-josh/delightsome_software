import 'package:delightsome_software/dataModels/materialStoreModels/productMaterials.model.dart';

class ProductMaterialItemModel {
  // String? key;
  ProductMaterialsModel item;
  int quantity;

  ProductMaterialItemModel({
    // this.key,
    required this.item,
    required this.quantity,
  });

  // get model from json
  factory ProductMaterialItemModel.fromJson(Map json) {
    return ProductMaterialItemModel(
      item: json['item'] != null
          ? ProductMaterialsModel.fromJson(json['item'])
          : ProductMaterialsModel(
              itemName: 'Deleted',
              category: '',
              quantity: 0,
              restockLimit: 0,
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
