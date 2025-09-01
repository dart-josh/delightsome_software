import 'package:delightsome_software/globalvariables.dart';
import 'package:delightsome_software/utils/offlineStore.dart';
import 'package:flutter/material.dart';

class OfflineRecordIndicator extends StatelessWidget {
  const OfflineRecordIndicator({
    super.key,
    required this.rec_key,
    this.showText = false,
  });

  final String? rec_key;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: offline_data,
        builder: (context, value, child) {
          if (OfflineStore.isOffline(rec_key))
            return SizedBox(
              child: Row(
                children: [
                  Icon(Icons.connected_tv, color: Colors.green, size: 20),
                  if (showText) SizedBox(width: 10),
                  if (showText) Text('Record is offline'),
                ],
              ),
            );
          else
            return SizedBox();
        });
  }
}
