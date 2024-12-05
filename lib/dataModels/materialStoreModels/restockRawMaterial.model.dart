import 'package:delightsome_software/dataModels/materialStoreModels/rawMaterialItem.model.dart';
import 'package:delightsome_software/dataModels/userModels/editedBy.model.dart';
import 'package:delightsome_software/dataModels/userModels/staff.model.dart';

class RestockRawMaterialModel {
  String? key;
  String? recordId;
  DateTime? recordDate;
  DateTime? verifiedDate;
  StaffModel? receiver;
  List<RawMaterialItemModel> items;
  List<RawMaterialItemModel> itemsUsed;
  String? shortNote;
  bool? verified;
  StaffModel? verifiedBy;
  bool? isEdited;
  List<EditedByModel>? editedBy;
  DateTime? createdAt;

  bool show_items_used = false;

  RestockRawMaterialModel({
    this.key,
    this.recordId,
    this.recordDate,
    this.verifiedDate,
    this.receiver,
    required this.items,
    required this.itemsUsed,
    this.shortNote,
    this.verified,
    this.verifiedBy,
    this.isEdited,
    this.editedBy,
    this.createdAt,
  });

  // get model from json
  factory RestockRawMaterialModel.fromJson(Map json) {
    return RestockRawMaterialModel(
      key: json['_id'],
      recordId: json['recordId'] ?? '',
      recordDate: (json['recordDate'] != null)
          ? DateTime.parse(json['recordDate'])
          : null,
      verifiedDate: json['verifiedDate'] != null
          ? DateTime.parse(json['verifiedDate'])
          : null,
      receiver: json['receiver'] != null ? StaffModel.fromJson(json['receiver']) : null,
      items: (json['items'] as List)
          .map((i) => RawMaterialItemModel.fromJson(i))
          .toList(),
      itemsUsed: (json['itemsUsed'] as List)
          .map((i) => RawMaterialItemModel.fromJson(i))
          .toList(),
      shortNote: json['shortNote'] ?? null,
      verified: json['verified'] ?? false,
      verifiedBy: json['verifiedBy'] != null
          ? StaffModel.fromJson(json['verifiedBy'])
          : null,
      isEdited: json['isEdited'] ?? false,
      editedBy: (json['editedBy'] as List)
          .map((i) => EditedByModel.fromJson(i))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // get json from model (add/update)
  Map enter_toJson({required String receiver, required String editedBy}) => {
        'id': key,
        'date': recordDate?.toIso8601String(),
        'receiver': receiver,
        'items': items.map((i) => i.toJson()).toList(),
        'itemsUsed': itemsUsed.map((i) => i.toJson()).toList(),
        'shortNote': shortNote,
        'editedBy': editedBy,
      };

  // get json from model (verification)
  Map verify_toJson({required String verifiedBy}) => {
        'id': key,
        'verifiedBy': verifiedBy,
      };
}
