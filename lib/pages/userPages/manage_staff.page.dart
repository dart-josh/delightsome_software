import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/userModels/staff.model.dart';
import 'package:delightsome_software/helpers/authHelpers.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/helpers/userHelpers.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:delightsome_software/widgets/select_form.dart';
import 'package:delightsome_software/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageStaffPage extends StatefulWidget {
  final StaffModel? staff;
  const ManageStaffPage({super.key, this.staff});

  @override
  State<ManageStaffPage> createState() => _ManageStaffPageState();
}

class _ManageStaffPageState extends State<ManageStaffPage> {
  final TextEditingController staff_id_controller = TextEditingController();
  final TextEditingController fullname_controller = TextEditingController();
  final TextEditingController nickname_controller = TextEditingController();

  List<String> staff_role_list = [
    'Management',
    'Production',
    'Sales',
    'Terminal',
    'Admin'
  ];

  String role = '';
  bool fullaccess = false;
  bool backdate = false;

  bool edit = false;
  bool new_cat = true;

  void get_values() {
    if (widget.staff == null) {
      new_cat = true;
      edit = true;
    } else {
      staff_id_controller.text = widget.staff!.staffId;
      fullname_controller.text = widget.staff!.fullname;
      nickname_controller.text = widget.staff!.nickName;
      role = widget.staff!.role;
      fullaccess = widget.staff!.fullaccess;
      backdate = widget.staff!.backDate;

      new_cat = false;
      edit = false;
    }
  }

  @override
  void initState() {
    get_values();
    super.initState();
  }

  @override
  void dispose() {
    staff_id_controller.dispose();
    fullname_controller.dispose();
    nickname_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;
    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320,
        height: 450,
        child: Column(
          children: [
            // top bar
            top_bar(),
            // content
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 5),
                padding: EdgeInsets.only(bottom: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDarkTheme
                      ? AppColors.dark_dialogBackground_1
                      : AppColors.light_dialogBackground_1,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Column(
                            children: [
                              // details
                              if (widget.staff != null) details(),

                              SizedBox(height: 20),

                              formBox(),

                              // SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    // submit
                    if (edit) submit_button(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGETS

  // top bar
  Widget top_bar() {
    var auth_staff = Provider.of<AppData>(context).active_staff;

    return Container(
      width: double.infinity,
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 8),
      color: AppColors.primaryForegroundColor,
      child: Stack(
        children: [
          // action buttons
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // close button
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: AppColors.secondaryWhiteIconColor,
                  size: 22,
                ),
              ),

              Expanded(child: Container()),

              // edit button
              if (!new_cat && auth_staff!.fullaccess)
                InkWell(
                  onTap: () {
                    edit = !edit;

                    if (!edit) get_values();
                    setState(() {});
                  },
                  child: Icon(
                    edit ? Icons.check_circle : Icons.edit,
                    color: AppColors.secondaryWhiteIconColor,
                    size: 20,
                  ),
                ),

              SizedBox(width: 10),

              // delete button
              if (edit && !new_cat && auth_staff!.fullaccess)
                InkWell(
                  onTap: () async {
                    bool? res = await UniversalHelpers.showConfirmBox(
                      context,
                      title: 'Delete Staff',
                      subtitle:
                          'This would permanently remove this staff from the database!\Would you like to proceed?',
                    );

                    if (res != null && res) {
                      bool done = await UserHelpers.delete_staff(
                          context, widget.staff!.key!);

                      if (done) Navigator.pop(context);
                    }
                  },
                  child: Icon(
                    Icons.delete,
                    color: AppColors.secondaryWhiteIconColor,
                    size: 20,
                  ),
                ),
            ],
          ),

          // title
          Center(
            child: Text(
              new_cat
                  ? 'New Staff'
                  : edit
                      ? 'Edit Staff'
                      : 'Manage Staff',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // details
  Widget details() {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    TextStyle labelStyle = TextStyle(
      fontSize: 12,
      color: isDarkTheme
          ? AppColors.dark_secondaryTextColor
          : AppColors.light_secondaryTextColor,
    );
    TextStyle mainStyle = TextStyle(
      fontSize: 16,
      color: isDarkTheme
          ? AppColors.dark_primaryTextColor
          : AppColors.light_primaryTextColor,
      fontWeight: FontWeight.bold,
    );

    return Container(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nickname', style: labelStyle),
              Text(widget.staff!.nickName, style: mainStyle),
            ],
          ),
          Expanded(child: Container()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Role', style: labelStyle),
              Text(widget.staff!.role, style: mainStyle),
            ],
          ),
        ],
      ),
    );
  }

  Widget formBox() {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    var auth_staff = Provider.of<AppData>(context).active_staff;

    TextStyle labelStyle = TextStyle(
      color: isDarkTheme ? Color(0xFFc3c3c3) : Color.fromARGB(255, 61, 61, 61),
      fontSize: 12,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // staff id
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text_field(
              controller: staff_id_controller,
              label: 'Staff ID',
              edit: !edit,
            ),
          ),

          // nickname
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text_field(
              controller: nickname_controller,
              label: 'Nickname',
              edit: !edit,
            ),
          ),

          // fullname
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text_field(
              controller: fullname_controller,
              label: 'Staff Fullname',
              edit: !edit,
            ),
          ),

          // staff role
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Select_form(
              label: 'Staff Role',
              edit: edit,
              options: staff_role_list,
              text_value: role,
              setval: (val) {
                role = val;
                setState(() {});
              },
            ),
          ),

          // full options
          if (auth_staff!.fullaccess)
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // full access
                  Column(
                    children: [
                      // label
                      Text('Full access', style: labelStyle),

                      Switch(
                        value: fullaccess,
                        onChanged: (value) {
                          if (edit)
                            setState(() {
                              fullaccess = value;
                            });
                        },
                      ),
                    ],
                  ),

                  // backdate
                  Column(
                    children: [
                      // label
                      Text('Backdate', style: labelStyle),

                      Switch(
                        value: backdate,
                        onChanged: (value) {
                          if (edit)
                            setState(() {
                              backdate = value;
                            });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

          SizedBox(height: 15),

          if (auth_staff.fullaccess && !new_cat && widget.staff != null)
            reset_password_button(widget.staff!.staffId),
        ],
      ),
    );
  }

  // submit button
  Widget submit_button() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () async {
          if (staff_id_controller.text.isEmpty) {
            UniversalHelpers.showToast(
              context: context,
              color: Colors.red,
              toastText: 'Enter Staff ID',
              icon: Icons.error,
            );
            return;
          }

          if (role.isEmpty) {
            UniversalHelpers.showToast(
              context: context,
              color: Colors.red,
              toastText: 'Select Staff Role',
              icon: Icons.error,
            );
            return;
          }

          if (nickname_controller.text.isEmpty) {
            UniversalHelpers.showToast(
              context: context,
              color: Colors.red,
              toastText: 'Enter Nickname',
              icon: Icons.error,
            );
            return;
          }

          if (fullname_controller.text.isEmpty) {
            UniversalHelpers.showToast(
              context: context,
              color: Colors.red,
              toastText: 'Enter Fullname',
              icon: Icons.error,
            );
            return;
          }

          Map map = StaffModel(
            key: widget.staff?.key,
            staffId: staff_id_controller.text.trim(),
            fullname: fullname_controller.text.trim(),
            nickName: nickname_controller.text.trim(),
            role: role,
            fullaccess: fullaccess,
            backDate: backdate,
          ).toJson();

          bool? res = await UniversalHelpers.showConfirmBox(
            context,
            title: 'Save Staff',
            subtitle:
                'This would save this staff to the database!\Would you like to proceed?',
          );

          if (res != null && res) {
            bool done = await UserHelpers.add_update_staff(context, map);

            if (done) Navigator.pop(context);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.orange_1,
            borderRadius: BorderRadius.circular(6),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check,
                  color: AppColors.secondaryWhiteIconColor,
                ),
                SizedBox(width: 8),
                Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // reset button
  Widget reset_password_button(String staff_id) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () async {
          bool? res = await UniversalHelpers.showConfirmBox(
            context,
            title: 'Reset Password',
            subtitle:
                'You are about to reset the password for this User!\Would you like to proceed?',
          );

          if (res != null && res) {
            bool done = await AuthHelpers.reset_password(context, staff_id);

            if (done) Navigator.pop(context);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red.shade400,
            borderRadius: BorderRadius.circular(6),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check,
                  color: AppColors.secondaryWhiteIconColor,
                ),
                SizedBox(width: 8),
                Text(
                  'Reset Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //
}
