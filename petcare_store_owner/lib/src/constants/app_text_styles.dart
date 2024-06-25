import 'package:flutter/material.dart';

/// AppTextStyle format as follows:
/// [fontWeight][fontSize][colorName][opacity]
/// Example: bold18White05
///
class AppTextStyles {
  static const TextStyle _title_regular = TextStyle(
    fontFamily: 'Catamaran',
    fontWeight: FontWeight.w400,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle _title_medium = TextStyle(
    fontFamily: 'Catamaran',
    fontWeight: FontWeight.w500,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle _title_bold = TextStyle(
    fontFamily: 'Catamaran',
    fontWeight: FontWeight.w700,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle _body_regular = TextStyle(
    fontFamily: 'Noto Sans',
    fontWeight: FontWeight.w400,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle _body_medium = TextStyle(
    fontFamily: 'Noto Sans',
    fontWeight: FontWeight.w500,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle _body_semiBold = TextStyle(
    fontFamily: 'Noto Sans',
    fontWeight: FontWeight.w600,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle _body_bold = TextStyle(
    fontFamily: 'Noto Sans',
    fontWeight: FontWeight.w700,
    overflow: TextOverflow.ellipsis,
  );

  static TextStyle titleRegular(double fontSize, Color color) {
    return _title_regular.copyWith(fontSize: fontSize, color: color);
  }

  static TextStyle titleMedium(double fontSize, Color color) {
    return _title_medium.copyWith(fontSize: fontSize, color: color);
  }

  static TextStyle titleBold(double fontSize, Color color) {
    return _title_bold.copyWith(fontSize: fontSize, color: color);
  }

  static TextStyle bodyRegular(double fontSize, Color color) {
    return _body_regular.copyWith(fontSize: fontSize, color: color);
  }

  static TextStyle bodyMedium(double fontSize, Color color) {
    return _body_medium.copyWith(fontSize: fontSize, color: color);
  }

  static TextStyle bodySemiBold(double fontSize, Color color) {
    return _body_semiBold.copyWith(fontSize: fontSize, color: color);
  }

  static TextStyle bodyBold(double fontSize, Color color) {
    return _body_bold.copyWith(fontSize: fontSize, color: color);
  }
}
