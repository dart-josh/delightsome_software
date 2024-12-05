import 'package:delightsome_software/dataModels/userModels/staff.model.dart';

class EditedByModel {
  String? key;
  StaffModel staff;
  DateTime time;

  EditedByModel({this.key, required this.staff, required this.time});

  // get model from json
  factory EditedByModel.fromJson(Map json) {
    return EditedByModel(
      key: json['_id'],
      staff: json['staff'] != null
          ? StaffModel.fromJson(json['staff'])
          : StaffModel(
              staffId: 'Deleted',
              fullname: '',
              nickName: 'Deleted',
              role: '',
              fullaccess: false,
              backDate: false,
            ),
      time: DateTime.parse(json['time']),
    );
  }
}
