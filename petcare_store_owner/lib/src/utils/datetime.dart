extension DateTimeExtension on DateTime {
  bool isDefault() => year == 1000 && month == 1 && day == 1;
}
