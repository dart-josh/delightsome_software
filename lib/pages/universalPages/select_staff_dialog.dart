import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/userModels/staff.model.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:delightsome_software/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectStaffDialog extends StatefulWidget {
  final String staff_label;
  final String note_label;
  final StaffModel? staff;
  final String? note;
  final DateTime? date;
  final String? additional_label;
  final String? additional_value;
  final String staff_list_type;

  const SelectStaffDialog({
    super.key,
    required this.staff_label,
    required this.note_label,
    required this.staff,
    required this.note,
    required this.date,
    this.additional_label,
    this.additional_value,
    required this.staff_list_type,
  });

  @override
  State<SelectStaffDialog> createState() => _SelectStaffDialogState();
}

class _SelectStaffDialogState extends State<SelectStaffDialog> {
  List<StaffModel> staffs = [];

  StaffModel? staff;

  TextEditingController note_controller = TextEditingController();
  TextEditingController date_controller = TextEditingController();
  TextEditingController additional_controller = TextEditingController();

  void set_values() {
    if (widget.staff != null) {
      var staf = Provider.of<AppData>(context, listen: false)
          .staff_list
          .where((e) => e.key == widget.staff!.key);
      if (staf.isNotEmpty) {
        staff = staf.first;
      }
    }

    note_controller.text = widget.note ?? '';
    date_controller.text = widget.date?.toString() ?? '';
    date = widget.date;
    additional_controller.text = widget.additional_value ?? '';
  }

  DateTime? date;

  get_staffs() {
    // ['Management', 'Production', 'Sales', 'Terminal', 'Dangote', 'Admin'];

    var all_staff = Provider.of<AppData>(context).staff_list;

    var sel_staff = all_staff.where((e) => !e.fullaccess).toList();

    staffs = sel_staff
        .where((staff) => widget.staff_list_type
            .toLowerCase()
            .contains(staff.role.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    set_values();
    super.initState();
  }

  @override
  void dispose() {
    note_controller.dispose();
    date_controller.dispose();
    additional_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    get_staffs();

    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    var auth_staff = Provider.of<AppData>(context).active_staff;

    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320,
        height: (auth_staff!.fullaccess || auth_staff.backDate) ? 350 : 290,
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
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Staff label
                        Text(
                          widget.staff_label,
                          style: TextStyle(
                            color: isDarkTheme
                                ? AppColors.dark_secondaryTextColor
                                : AppColors.light_secondaryTextColor,
                          ),
                        ),

                        SizedBox(height: 5),

                        // select staff
                        DropdownButtonFormField<StaffModel>(
                          decoration: InputDecoration(
                            labelText: 'Staff',
                            labelStyle: TextStyle(
                              color: isDarkTheme
                                  ? AppColors.dark_secondaryTextColor
                                  : AppColors.light_secondaryTextColor,
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(15, 12, 10, 12),
                          ),
                          dropdownColor: isDarkTheme
                              ? AppColors.dark_primaryBackgroundColor
                              : AppColors.light_dialogBackground_1,
                          value: staff,
                          items: staffs.isNotEmpty
                              ? staffs
                                  .map((e) => DropdownMenuItem<StaffModel>(
                                      value: e, child: Text(e.nickName)))
                                  .toList()
                              : [],
                          onChanged: (val) {
                            if (val != null) {
                              staff = val;

                              setState(() {});
                            }
                          },
                        ),

                        SizedBox(height: 15),

                        // short note
                        Text_field(
                          controller: note_controller,
                          label: widget.note_label,
                        ),

                        if (widget.additional_value != null ||
                            widget.additional_label != null)
                          SizedBox(height: 8),

                        // additional label
                        if (widget.additional_value != null ||
                            widget.additional_label != null)
                          Text_field(
                            controller: additional_controller,
                            label: widget.additional_label ?? '',
                          ),

                        if (auth_staff.fullaccess || auth_staff.backDate)
                          SizedBox(height: 15),

                        // date
                        if (auth_staff.fullaccess || auth_staff.backDate)
                          Text_field(
                            controller: date_controller,
                            icon: InkWell(
                              onTap: () async {
                                var data = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(DateTime.now().year,
                                        DateTime.now().month - 3, 1),
                                    lastDate: DateTime.now(),
                                    initialDate: DateTime.tryParse(
                                            date_controller.text) ??
                                        DateTime.now());

                                if (data != null) {
                                  date = data;
                                  date_controller.text = data.toString();
                                  setState(() {});
                                } else {
                                  date = null;
                                  date_controller.text = '';
                                  setState(() {});
                                }
                              },
                              child: Icon(
                                Icons.calendar_month,
                                color: isDarkTheme
                                    ? AppColors.dark_secondaryTextColor
                                    : const Color.fromARGB(137, 52, 49, 49),
                              ),
                            ),
                          ),

                        SizedBox(height: 30),

                        // submit
                        if (staff != null) submit_button(),
                      ],
                    ),
                  ),
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
            ],
          ),

          // title
          Center(
            child: Text(
              'Complete Form',
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

  // submit button
  Widget submit_button() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () {
          if (staff == null) {
            UniversalHelpers.showToast(
              context: context,
              color: Colors.red,
              toastText: 'Select a staff',
              icon: Icons.error,
            );
            return;
          }

          if (widget.date != null) {
            if (date_controller.text.isEmpty) {
              UniversalHelpers.showToast(
                context: context,
                color: Colors.red,
                toastText: 'Date cannot be empty',
                icon: Icons.error,
              );
              return;
            }

            var dt =
                DateTime.tryParse(date_controller.text.replaceAll('Z', ''));
            if (dt == null) {
              UniversalHelpers.showToast(
                context: context,
                color: Colors.red,
                toastText: 'Invalid date',
                icon: Icons.error,
              );
              return;
            }

            Navigator.pop(context, [
              staff,
              note_controller.text.trim(),
              dt,
              additional_controller.text.trim()
            ]);
          } else {
            var dt =
                DateTime.tryParse(date_controller.text.replaceAll('Z', ''));
            Navigator.pop(context, [
              staff,
              note_controller.text.trim(),
              dt,
              additional_controller.text.trim()
            ]);
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

//
}
