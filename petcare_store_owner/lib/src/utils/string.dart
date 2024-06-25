extension StringExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');

  List<double> toDoubleList() {
    List<String> parts = substring(1, length - 2).split(',');
    return parts
        .map((s) => double.parse(s))
        .map((d) => double.parse(d.toStringAsFixed(1)))
        .toList();
  }
}
