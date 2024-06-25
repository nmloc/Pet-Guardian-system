import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:petcare_store_owner/src/constants/app_sizes.dart';

class CustomSurffixIcon extends StatelessWidget {
  const CustomSurffixIcon({
    Key? key,
    required this.svgIcon,
  }) : super(key: key);

  final String svgIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        proportionateWidth(20),
        proportionateWidth(20),
        proportionateWidth(20),
      ),
      child: SvgPicture.asset(
        svgIcon,
        height: proportionateWidth(18),
      ),
    );
  }
}
