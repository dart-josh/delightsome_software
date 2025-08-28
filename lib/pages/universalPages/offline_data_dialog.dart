import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OfflineDataDialog extends StatefulWidget {
  const OfflineDataDialog({super.key});

  @override
  State<OfflineDataDialog> createState() => _OfflineDataDialogState();
}

class _OfflineDataDialogState extends State<OfflineDataDialog> {
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
                      children: [],
                    ),
                  ),
                ),
              ),
            ),

            // recconect button
            recconect_button(),
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

              // refresh button
              InkWell(
                onTap: () async {},
                child: Icon(
                  Icons.refresh_rounded,
                  color: AppColors.secondaryWhiteIconColor,
                  size: 24,
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
  Widget recconect_button() {
    var isConnected = Provider.of<AppData>(context).connection_status;

    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 35,
        padding: EdgeInsets.symmetric(horizontal: 8),
        color: AppColors.orange_1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isConnected ? Icons.cloud_upload : Icons.refresh_rounded, size: 23, color: Colors.white60,),
            SizedBox(width: 4),
            Text(
              isConnected ? 'Upload Record' : 'Reconnect',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

//
}
