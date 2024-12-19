class StaffModel {
  String? key;
  String staffId;
  String fullname;
  String nickName;
  String role;
  bool fullaccess;
  bool backDate;
  bool active;

  StaffModel({
    this.key,
    required this.staffId,
    required this.fullname,
    required this.nickName,
    required this.role,
    required this.fullaccess,
    required this.backDate,
    required this.active,
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
      active: json['active'] ?? true,
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
        'active': active,
      };
}
