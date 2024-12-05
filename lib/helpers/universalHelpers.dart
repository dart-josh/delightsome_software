import 'dart:math';

import 'package:delightsome_software/widgets/confirm_dailog.dart';
import 'package:delightsome_software/widgets/loadingScreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class UniversalHelpers {
  // ROUTES
// show toast
  static void showToast(
      {required BuildContext context,
      required Color color,
      required String toastText,
      required IconData icon}) {
    FToast fToast = FToast();
    fToast.init(context);

    var size = MediaQuery.of(context).size;

    Widget toast = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: size.width > 600 ? 500 : 300,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 15,
            ),
            SizedBox(
              width: 10,
            ),
            if (toastText.length > 25 && size.width < 600)
              Expanded(
                child: Text(
                  toastText,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              )
            else
              Text(
                toastText,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
          ],
        ),
      ),
    );

    fToast.removeCustomToast();
    fToast.removeQueuedCustomToasts();

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  // show loading screen
  static void showLoadingScreen({required BuildContext context}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (context) => LoadingScreen(),
    );
  }

  // show confrim box
  static Future<bool?> showConfirmBox(BuildContext context,
      {required String title, required String subtitle}) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (context) => ConfirmDialog(title: title, subtitle: subtitle),
    );
  }

  static String generate_key() {
    return Random().nextInt(150).toString();
  }

  // format numbers
  static String format_number(int number, {bool currency = false}) {
    if (currency)
      return '₦${NumberFormat('#,###').format(number)}';
    else
      return NumberFormat('#,###').format(number);
  }

  // get month
  static DateTime get_month(DateTime date) {
    return DateTime(date.year, date.month);
  }

  // format month
  static String format_month_to_string(DateTime date, {bool full = false}) {
    if (full)
      return DateFormat('MMMM y').format(date);
    else
      return DateFormat('MMM y').format(date);
  }

  // get date
  static DateTime get_date(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // format date
  static String format_date_to_string(DateTime date, {bool full = false}) {
    if (full)
      return DateFormat('E, MMMM d, y').format(date);
    else
      return DateFormat('E, MMM d, y').format(date);
  }

  static String get_raw_date(DateTime date) {
    return date.toIso8601String().split('T')[0];
  }

  static String get_raw_month(DateTime date) {
    return '${date.toIso8601String().split('T')[0].split('-')[0]}-${date.toIso8601String().split('T')[0].split('-')[1]}';
  }

  static String format_time_to_string(DateTime? date) {
    if (date == null) return '';
    return DateFormat('h:mm a, dd/MM/yyyy').format(date);
  }

  //
}
