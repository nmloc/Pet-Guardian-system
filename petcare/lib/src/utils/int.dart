extension IntExtension on int {
  String toVND() {
    String priceString = toString();
    String formattedPrice = '';
    int length = priceString.length;
    for (int i = 0; i < length; i++) {
      if ((length - i) % 3 == 0 && i != 0) {
        formattedPrice += '.';
      }
      formattedPrice += priceString[i];
    }
    return '$formattedPrice VND';
  }

  String formatPrice() {
    String priceString = toString();
    String formattedPrice = '';
    int length = priceString.length;
    for (int i = 0; i < length; i++) {
      if ((length - i) % 3 == 0 && i != 0) {
        formattedPrice += '.';
      }
      formattedPrice += priceString[i];
    }
    return formattedPrice;
  }

  String toDayOfWeek({bool isShorten = false}) {
    switch (this) {
    case 1:
      return isShorten ? "Mon" : "Monday";
    case 2:
      return isShorten ? "Tue" : "Tuesday";
    case 3:
      return isShorten ? "Wed" : "Wednesday";
    case 4:
      return isShorten ? "Thu" : "Thursday";
    case 5:
      return isShorten ? "Fri" : "Friday";
    case 6:
      return isShorten ? "Sat" : "Saturday";
    case 7:
      return isShorten ? "Sun" : "Sunday";
    default:
      return "Invalid";
  }
  }
}