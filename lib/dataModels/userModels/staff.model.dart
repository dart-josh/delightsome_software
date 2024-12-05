class StaffModel {
  String? key;
  String staffId;
  String fullname;
  String nickName;
  String role;
  bool fullaccess;
  bool backDate;

  StaffModel({
    this.key,
    required this.staffId,
    required this.fullname,
    required this.nickName,
    required this.role,
    required this.fullaccess,
    required this.backDate,
  });

  // get model from json
  factory StaffModel.fromJson(Map json) {
    return StaffModel(
      key: json['_id'],
      staffId: json['staffId'] ?? '',
      fullname: json['fullname'] ?? '',
      nickName: json['nickName'] ?? '',
      role: json['role'] ?? '',
      fullaccess: json['fullaccess'] ?? false,
      backDate: json['backDate'] ?? false,
    );
  }

  // get json from model
  Map toJson() => {
        'id': key,
        'staffId': staffId,
        'fullname': fullname,
        'nickName': nickName,
        'role': role,
        'fullaccess': fullaccess,
        'backDate': backDate,
      };
}
