import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyUtils {
  static String formatNumber(int number) {
    return NumberFormat.decimalPattern('id').format(number);
  }

  static void showUnavailableSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Not available in this version'),
    ));
  }

  static Future showLoading(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator()
          ],
        ),
        contentPadding: EdgeInsets.all(32),
      ),
      barrierDismissible: false,
    );
  }
}