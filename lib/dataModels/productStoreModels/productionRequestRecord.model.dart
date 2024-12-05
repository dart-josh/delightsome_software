// import 'package:delightsome_software/dataModels/productStoreModels/productItem.model.dart';
// import 'package:delightsome_software/dataModels/userModels/editedBy.model.dart';
// import 'package:delightsome_software/dataModels/userModels/staff.model.dart';

// class ProductionRequestRecordModel {
//   String key;
//   DateTime? verifiedDate;
//   StaffModel requestTo;
//   StaffModel requestFrom;
//   List<ProductItemModel> products;
//   String shortNote;
//   bool verified;
//   StaffModel? verifiedBy;
//   int totalQuantity;
//   bool isEdited;
//   List<EditedByModel> editedBy;
//   bool viewed;
//   DateTime? viewedTime;

//   ProductionRequestRecordModel({
//     required this.key,
//     this.verifiedDate,
//     required this.requestTo,
//     required this.requestFrom,
//     required this.products,
//     required this.shortNote,
//     required this.verified,
//     this.verifiedBy,
//     required this.totalQuantity,
//     required this.isEdited,
//     required this.editedBy,
//     required this.viewed,
//     this.viewedTime,
//   });

//   // get model from json
//   factory ProductionRequestRecordModel.fromJson(Map json) {
//     return ProductionRequestRecordModel(
//       key: json['_id'] as String,
//       verifiedDate: json['verifiedDate'] == null
//           ? null
//           : DateTime.parse(json['verifiedDate'] as String),
//       requestTo: StaffModel.fromJson(json['requestTo'] as Map),
//       requestFrom: StaffModel.fromJson(json['requestFrom'] as Map),
//       products: List<ProductItemModel>.from(
//         json['products'].map(
//           (x) => ProductItemModel.fromJson(x as Map),
//         ),
//       ),
//       shortNote: json['shortNote'] as String,
//       verified: json['verified'] as bool,
//       verifiedBy: json['verifiedBy'] == null
//           ? null
//           : StaffModel.fromJson(json['verifiedBy'] as Map),
//       totalQuantity: json['totalQuantity'] as int,
//       isEdited: json['isEdited'] as bool,
//       editedBy: List<EditedByModel>.from(
//         json['editedBy'].map(
//           (x) => EditedByModel.fromJson(x as Map),
//         ),
//       ),
//       viewed: json['viewed'] as bool,
//       viewedTime: json['viewedTime'] == null
//           ? null
//           : DateTime.parse(json['viewedTime'] as String),
//     );
//   }

//   // get json from model
//   Map toJson() => {
//         'verifiedDate': verifiedDate?.toIso8601String(),
//         'requestTo': requestTo.toJson(),
//         'requestFrom': requestFrom.toJson(),
//         'products': List<dynamic>.from(products.map((x) => x.toJson())),
//         'shortNote': shortNote,
//         'verified': verified,
//         'verifiedBy': verifiedBy?.toJson(),
//         'totalQuantity': totalQuantity,
//         'isEdited': isEdited,
//         'editedBy': List<dynamic>.from(editedBy.map((x) => x.toJson())),
//         'viewed': viewed,
//         'viewedTime': viewedTime?.toIso8601String(),
//       };
// }
