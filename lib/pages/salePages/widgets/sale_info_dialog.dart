import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/globalvariables.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleInfoDialog extends StatefulWidget {
  final String order_id;
  const SaleInfoDialog({super.key, required this.order_id});

  @override
  State<SaleInfoDialog> createState() => _SaleInfoDialogState();
}

class _SaleInfoDialogState extends State<SaleInfoDialog> {
  @override
  Widget build(BuildContext context) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

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
                          widget.order_id,
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

                        if (activeStaff!.fullaccess)
                          InkWell(
                            onTap: () {
                              Navigator.pop(context, 'change_pmt');
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
                                  Icon(Icons.change_circle_outlined, size: 16),
                                  SizedBox(width: 4),
                                  Text('Change Payment Method'),
                                ],
                              ),
                            ),
                          ),

                        SizedBox(height: 20),
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

              // delete button
              if (activeStaff!.fullaccess)
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
}
