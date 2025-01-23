import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/userModels/editedBy.model.dart';
import 'package:delightsome_software/dataModels/userModels/staff.model.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordInfoDialog extends StatefulWidget {
  final bool approved;
  final String? approvedBy;
  final DateTime? approvedDate;
  final List<EditedByModel> editedBy;
  final String approve_label;
  final StaffModel staff;
  final String recordId;
  final String auth_approve_staff;

  const RecordInfoDialog({
    super.key,
    required this.approved,
    required this.approvedBy,
    required this.approvedDate,
    required this.editedBy,
    required this.approve_label,
    required this.staff,
    required this.recordId,
    required this.auth_approve_staff,
  });

  @override
  State<RecordInfoDialog> createState() => _RecordInfoDialogState();
}

class _RecordInfoDialogState extends State<RecordInfoDialog> {
  @override
  Widget build(BuildContext context) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    var auth_staff = Provider.of<AppData>(context).active_staff;

    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320,
        height: 300,
        child: Column(
          children: [
            // top bar
            top_bar(),

            // content
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 5, bottom: 2),
                padding: EdgeInsets.only(bottom: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDarkTheme
                      ? AppColors.dark_dialogBackground_1
                      : AppColors.light_dialogBackground_1,
                ),
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      children: [
                        // record Id
                        Text(
                          widget.recordId,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            color: isDarkTheme
                                ? AppColors.dark_secondaryTextColor
                                : AppColors.light_secondaryTextColor,
                          ),
                        ),

                        SizedBox(height: 10),

                        // approved/approveBy
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isDarkTheme
                                  ? AppColors.dark_dimTextColor
                                  : AppColors.light_dimTextColor,
                            ),
                            borderRadius: BorderRadius.circular(1),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: (widget.approved)
                              ? Row(
                                  children: [
                                    Icon(Icons.verified, size: 16),
                                    SizedBox(width: 4),
                                    Text(widget.approvedBy ?? 'Admin')
                                  ],
                                )
                              : Text(
                                  'Not ${widget.approve_label == 'Authorize' ? 'Authorized' : 'Verified'}'),
                        ),

                        SizedBox(height: 10),

                        // approved date
                        if (widget.approved && widget.approvedDate != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isDarkTheme
                                    ? AppColors.dark_dimTextColor
                                    : AppColors.light_dimTextColor,
                              ),
                              borderRadius: BorderRadius.circular(1),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      '${widget.approve_label == 'Authorize' ? 'Authorized' : 'Verified'} : '),
                                ),
                                Text(
                                  UniversalHelpers.format_time_to_string(
                                      widget.approvedDate),
                                ),
                              ],
                            ),
                          )

                        // approve action button
                        else if (auth_staff!.role == 'Admin' ||
                            auth_staff.fullaccess ||
                            auth_staff.role == widget.auth_approve_staff)
                          InkWell(
                            onTap: () async {
                              var res = await UniversalHelpers.showConfirmBox(
                                context,
                                title: '${widget.approve_label}',
                                subtitle:
                                    'You are about to ${widget.approve_label} this record. Would you like to proceed?',
                              );

                              if (res != null && res)
                                Navigator.pop(context, widget.approve_label);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isDarkTheme
                                    ? AppColors.dark_primaryBackgroundColor
                                    : AppColors.light_dialogBackground_3,
                                border: Border.all(
                                  color: isDarkTheme
                                      ? AppColors.dark_dimTextColor
                                      : AppColors.light_dimTextColor,
                                ),
                                borderRadius: BorderRadius.circular(1),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.verified, size: 16),
                                  SizedBox(width: 4),
                                  Text(widget.approve_label),
                                ],
                              ),
                            ),
                          ),

                        SizedBox(height: 20),

                        // edited by label
                        if (widget.editedBy.isNotEmpty)
                          Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: isDarkTheme
                                        ? AppColors.dark_dimTextColor
                                        : AppColors.light_dimTextColor,
                                  ),
                                ),
                              ),
                              child: Text('Edited By : ')),

                        SizedBox(height: 5),

                        // edited by
                        if (widget.editedBy.isNotEmpty)
                          Column(
                            children: widget.editedBy
                                .map(
                                  (edit) => Container(
                                    decoration: BoxDecoration(
                                      color: isDarkTheme
                                          ? AppColors.dark_dimTextColor
                                          : AppColors.light_dimTextColor,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Text(edit.staff.nickName)),
                                        SizedBox(width: 5),
                                        Text(UniversalHelpers
                                            .format_time_to_string(edit.time)),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // edit button
            if ((widget.staff.staffId == auth_staff!.staffId ||
                    auth_staff.role == 'Admin' ||
                    auth_staff.fullaccess) &&
                !widget.approved)
              edit_button(),
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

              // delete button
              if (((widget.staff.staffId == auth_staff!.staffId ||
                          auth_staff.role == 'Admin') &&
                      !widget.approved) ||
                  (auth_staff.fullaccess))
                InkWell(
                  onTap: () async {
                    var res = await UniversalHelpers.showConfirmBox(
                      context,
                      title: 'Delete Record',
                      subtitle:
                          'You are about to delete this record. Would you like to proceed?',
                    );

                    if (res != null && res) Navigator.pop(context, 'delete');
                  },
                  child: Icon(
                    Icons.delete,
                    color: AppColors.secondaryWhiteIconColor,
                    size: 22,
                  ),
                ),
            ],
          ),

          // title
          Center(
            child: Text(
              'More Info',
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

  // edit button
  Widget edit_button() {
    return InkWell(
      onTap: () {
        Navigator.pop(context, 'edit');
      },
      child: Container(
        width: double.infinity,
        height: 35,
        padding: EdgeInsets.symmetric(horizontal: 8),
        color: AppColors.orange_1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Edit Record',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

//
}
