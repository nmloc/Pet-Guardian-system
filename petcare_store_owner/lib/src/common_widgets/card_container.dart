import 'package:flutter/material.dart';
import 'package:petcare_store_owner/src/constants/app_sizes.dart';
import 'package:petcare_store_owner/src/utils/color.dart';

class CardContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final Color? background;
  final bool enableShadow;
  const CardContainer({
    Key? key,
    required this.enableShadow,
    this.child,
    this.background,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: proportionateWidth(80),
        width: width,
        padding: EdgeInsets.symmetric(
            vertical: proportionateHeight(12),
            horizontal: proportionateWidth(14)),
        decoration: BoxDecoration(
          color: background ?? Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: enableShadow == true
              ? [
                  BoxShadow(
                      color: HexColor('0C1A4B').withOpacity(0.1),
                      blurRadius: 8),
                  BoxShadow(
                    color: HexColor('323247').withOpacity(0.02),
                    offset: const Offset(0, 4),
                    blurRadius: 20,
                    spreadRadius: -2,
                  )
                ]
              : [],
        ),
        child: child);
  }
}
