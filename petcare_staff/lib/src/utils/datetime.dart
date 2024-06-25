import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  bool isDefault() => year <= 1001;

  String format({String pattern = 'd MMM y'}) {
    return DateFormat(pattern).format(this);
  }
}
