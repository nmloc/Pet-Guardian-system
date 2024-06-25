import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  bool isDefault() => year < 1002;

  int toAge() {
    final now = DateTime.now();
    int age = now.year - year;
    // Check if the date has occurred this year
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }

  String format({String pattern = 'd MMM y'}) {
    return DateFormat(pattern).format(this);
  }

  DateTime addMonths(int num) {
    // Calculate the new year and month
    int newYear = year + ((month + num - 1) ~/ 12);
    int newMonth = (month + num) % 12;

    // If the new month is 0, set it to 12
    if (newMonth == 0) newMonth = 12;

    // If the current day exceeds the last day of the new month, set it to the last day of the new month
    int newDay = day;
    if (newDay > DateTime(newYear, newMonth + 1, 0).day) {
      newDay = DateTime(newYear, newMonth + 1, 0).day;
    }

    // Create the new DateTime object
    DateTime newDateTime = DateTime(newYear, newMonth, newDay, hour, minute,
        second, millisecond, microsecond);

    return newDateTime;
  }
}
