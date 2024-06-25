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
}