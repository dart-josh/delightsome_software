import 'package:delightsome_software/dataModels/materialStoreModels/rawMaterialItem.model.dart';
import 'package:delightsome_software/dataModels/userModels/editedBy.model.dart';
import 'package:delightsome_software/dataModels/userModels/staff.model.dart';

class RawMaterialsRequestModel {
  String? key;
  String? recordId;
  DateTime? recordDate;
  DateTime? authorizedDate;
  StaffModel? receiver;
  List<RawMaterialItemModel> items;
  String? purpose;
  bool? authorized;
  StaffModel? authorizedBy;
  bool? isEdited;
  List<EditedByModel>? editedBy;
  DateTime? createdAt;

  RawMaterialsRequestModel({
    this.key,
    this.recordId,
    this.recordDate,
    this.authorizedDate,
    this.receiver,
    required this.items,
    this.purpose,
    this.authorized,
    this.authorizedBy,
    this.isEdited,
    this.editedBy,
    this.createdAt,
  });

  // get model from json
  factory RawMaterialsRequestModel.fromJson(Map json) {
    return RawMaterialsRequestModel(
      key: json['_id'],
      recordId: json['recordId'] ?? '',
      recordDate: (json['recordDate'] != null)
          ? DateTime.parse(json['recordDate'])
          : null,
      authorizedDate: json['authorizedDate'] != null
          ? DateTime.parse(json['authorizedDate'])
          : null,
      receiver: json['receiver'] != null ? StaffModel.fromJson(json['receiver']) : null,
      items: (json['items'] as List)
          .map((i) => RawMaterialItemModel.fromJson(i))
          .toList(),
      purpose: json['purpose'] ?? null,
      authorized: json['authorized'] ?? false,
      authorizedBy: json['authorizedBy'] != null
          ? StaffModel.fromJson(json['authorizedBy'])
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
        'purpose': purpose,
        'editedBy': editedBy,
      };

  // get json from model (verification)
  Map verify_toJson({required String authorizedBy}) => {
        'id': key,
        'authorizedBy': authorizedBy,
      };
}
