import 'package:delightsome_software/dataModels/productStoreModels/product.model.dart';

class ProductItemModel {
  String? key;
  ProductModel product;
  int quantity;
  int price;

  ProductItemModel({
    this.key,
    required this.product,
    required this.quantity,
    this.price = 0,
  });

  // get model from json
  factory ProductItemModel.fromJson(Map json) {
    return ProductItemModel(
      key: json['_id'],
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : ProductModel(
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
      quantity: json['quantity'] ?? 0,
      price: json['price'] ?? 0,
    );
  }

  // get json from model
  Map toJson() => {
        'product': product.key,
        'quantity': quantity,
        'price': price,
      };

  ProductItemModel.copy(ProductItemModel model)
      : product = model.product,
        quantity = model.quantity,
        price = model.price;
}
