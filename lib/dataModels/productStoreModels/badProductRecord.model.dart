import 'package:delightsome_software/dataModels/productStoreModels/productItem.model.dart';
import 'package:delightsome_software/dataModels/userModels/editedBy.model.dart';
import 'package:delightsome_software/dataModels/userModels/staff.model.dart';

class BadProductRecordModel {
  String? key;
  String? recordId;
  DateTime? recordDate;
  DateTime? verifiedDate;
  StaffModel? staffResponsible;
  List<ProductItemModel> products;
  String? shortNote;
  bool? verified;
  StaffModel? verifiedBy;
  int? totalQuantity;
  bool? isEdited;
  List<EditedByModel>? editedBy;
  DateTime? createdAt;

  BadProductRecordModel({
    this.key,
    this.recordId,
    this.recordDate,
    this.verifiedDate,
    this.staffResponsible,
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
  factory BadProductRecordModel.fromJson(Map json) {
    return BadProductRecordModel(
      key: json['_id'],
      recordId: json['recordId'] ?? '',
      recordDate: (json['recordDate'] != null)
          ? DateTime.parse(json['recordDate'])
          : null,
      verifiedDate: json['verifiedDate'] != null
          ? DateTime.parse(json['verifiedDate'])
          : null,
      staffResponsible: json['staffResponsible'] != null ? StaffModel.fromJson(json['staffResponsible']) : null,
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
  Map enter_toJson(
          {required String staffResponsible, required String editedBy}) =>
      {
        'id': key,
        'date': recordDate?.toIso8601String(),
        'staffResponsible': staffResponsible,
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
