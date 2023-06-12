import 'package:intl/intl.dart';

class MyUtils {
  static String formatNumber(int number) {
    return NumberFormat.decimalPattern('id').format(number);
  }
}