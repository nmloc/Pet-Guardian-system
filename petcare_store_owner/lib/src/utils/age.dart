extension AgeExtension on DateTime {
  int toAge() {
    final now = DateTime.now();
    int age = now.year - year;
    // Check if the date has occurred this year
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }
}
