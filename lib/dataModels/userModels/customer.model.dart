class CustomerModel {
  String? key;
  String fullname;
  String nickName;
  String contactPhone;
  String address;
  String birthday;
  String customerType;
  String gender;

  CustomerModel({
    this.key,
    required this.fullname,
    required this.nickName,
    required this.contactPhone,
    required this.address,
    required this.birthday,
    required this.customerType,
    required this.gender,
  });

  // get model from json
  factory CustomerModel.fromJson(Map json) {
    return CustomerModel(
      key: json['_id'],
      fullname: json['fullname'] ?? '',
      nickName: json['nickName'] ?? '',
      contactPhone: json['contactPhone'] ?? '',
      address: json['address'] ?? '',
      birthday: json['birthday'] ?? '',
      customerType: json['customerType'] ?? '',
      gender: json['gender'] ?? '',
    );
  }

  // get json from model
  Map toJson() => {
        'id': key,
        'fullname': fullname,
        'nickName': nickName,
        'contactPhone': contactPhone,
        'address': address,
        'birthday': birthday,
        'customerType': customerType,
        'gender': gender,
      };
}
