class AuthModel {
  String staff_id;
  String password;
  String role;
  String? pin;

  AuthModel({
    required this.staff_id,
    required this.password,
    required this.role,
    this.pin,
  });

  factory AuthModel.fromJson(Map json) {
    return AuthModel(
      staff_id: json['staff_id'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      pin: json['pin'] ?? null,
    );
  }

  Map toJson() => {
        'staff_id': staff_id,
        'password': password,
        'role': role,
        'pin': pin,
      };
}
