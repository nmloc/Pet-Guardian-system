import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:petcare_staff/src/constants/app_sizes.dart';

class FormError extends StatelessWidget {
  const FormError({
    Key? key,
    required this.errors,
  }) : super(key: key);

  final List<String?> errors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          errors.length, (index) => formErrorText(error: errors[index]!)),
    );
  }

  Row formErrorText({required String error}) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/icons/Error.svg",
          height: proportionateWidth(14),
          width: proportionateWidth(14),
        ),
        SizedBox(
          width: proportionateWidth(10),
        ),
        Text(error),
      ],
    );
  }
}
