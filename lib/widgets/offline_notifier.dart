import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/globalvariables.dart';
import 'package:delightsome_software/pages/universalPages/offline_data_dialog.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OfflineNotifier extends StatelessWidget {
  const OfflineNotifier({super.key});

  @override
  Widget build(BuildContext context) {
    bool isConnected = Provider.of<AppData>(context).connection_status;

    return ValueListenableBuilder(
      valueListenable: offline_data,
      builder: (context, value, child) {
        int count = value.length;

        return Stack(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  // OfflineStore.clear_offline_data();
                  // return;
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => OfflineDataDialog(),
                  );
                },
                child: Container(
                  width: 43,
                  height: 43,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isConnected
                        ? AppColors.light_dialogBackground_1
                        : Colors.grey.shade300.withAlpha(200),
                  ),
                  margin:
                      (count > 0) ? EdgeInsets.only(top: 8, right: 8) : null,
                  child: Center(
                    child: Icon(
                      isConnected ? Icons.connected_tv : Icons.wifi_off,
                      color: isConnected ? Colors.green : Colors.grey,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ),
            if (count > 0)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 23,
                  height: 23,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Center(
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
