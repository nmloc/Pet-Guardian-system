import 'package:flutter/material.dart';
import 'package:petcare_staff/src/constants/app_sizes.dart';
import 'package:petcare_staff/src/utils/color.dart';

class CardContainer extends StatelessWidget {
  final Widget? child;
  final double? height;
  final double width;
  final Color? background;
  final bool enableShadow;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Clip? clipBehavior;

  CardContainer({
    Key? key,
    this.child,
    this.height,
    this.width = double.infinity,
    this.background,
    this.enableShadow = true,
    this.padding,
    this.margin,
    this.clipBehavior,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: clipBehavior ?? Clip.none,
      height: height ?? proportionateHeight(78),
      width: width,
      margin: margin,
      padding: padding ??
          EdgeInsets.symmetric(
              vertical: proportionateHeight(12),
              horizontal: proportionateWidth(14)),
      decoration: BoxDecoration(
        color: background ?? Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: enableShadow
            ? [
                BoxShadow(
                    color: HexColor('0C1A4B').withOpacity(0.1), blurRadius: 8),
                BoxShadow(
                  color: HexColor('323247').withOpacity(0.02),
                  offset: const Offset(0, 4),
                  blurRadius: 20,
                  spreadRadius: -2,
                )
              ]
            : [],
      ),
      child: child,
    );
  }
}
