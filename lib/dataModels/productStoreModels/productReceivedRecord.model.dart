import 'package:delightsome_software/dataModels/productStoreModels/productItem.model.dart';
import 'package:delightsome_software/dataModels/userModels/editedBy.model.dart';
import 'package:delightsome_software/dataModels/userModels/staff.model.dart';

class ProductReceivedRecordModel {
  String? key;
  String? recordId;
  DateTime? recordDate;
  DateTime? verifiedDate;
  StaffModel? receiver;
  String? supplier;
  List<ProductItemModel> products;
  String? shortNote;
  bool? verified;
  StaffModel? verifiedBy;
  int? totalQuantity;
  bool? isEdited;
  List<EditedByModel>? editedBy;
  DateTime? createdAt;

  ProductReceivedRecordModel({
    this.key,
    this.recordId,
    this.recordDate,
    this.verifiedDate,
    this.receiver,
    this.supplier,
    required this.products,
    this.shortNote,
    this.verified,
    this.verifiedBy,
    this.totalQuantity,
    this.isEdited,
    this.editedBy,
    this.createdAt,
  });

  // get model from json
  factory ProductReceivedRecordModel.fromJson(Map json) {
    return ProductReceivedRecordModel(
      key: json['_id'],
      recordId: json['recordId'] ?? '',
      recordDate: (json['recordDate'] != null)
          ? DateTime.parse(json['recordDate'])
          : null,
      verifiedDate: json['verifiedDate'] != null
          ? DateTime.parse(json['verifiedDate'])
          : null,
      receiver: json['receiver'] != null ? StaffModel.fromJson(json['receiver']) : null,
      supplier: json['supplier'] ?? null,
      products: (json['products'] as List)
          .map((x) => ProductItemModel.fromJson(x))
          .toList(),
      shortNote: json['shortNote'] ?? null,
      verified: json['verified'] ?? false,
      verifiedBy: json['verifiedBy'] != null
          ? StaffModel.fromJson(json['verifiedBy'])
          : null,
      totalQuantity: json['totalQuantity'] ?? 0,
      isEdited: json['isEdited'] ?? false,
      editedBy: (json['editedBy'] as List)
          .map((x) => EditedByModel.fromJson(x))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // get json from model (add/update)
  Map enter_toJson({required String receiver, required String editedBy}) => {
        'id': key,
        'date': recordDate?.toIso8601String(),
        'receiver': receiver,
        'supplier': supplier,
        'products': products.map((x) => x.toJson()).toList(),
        'shortNote': shortNote,
        'editedBy': editedBy,
      };

  // get json from model (verification)
  Map verify_toJson({required String verifiedBy}) => {
        'id': key,
        'verifiedBy': verifiedBy,
      };
}
