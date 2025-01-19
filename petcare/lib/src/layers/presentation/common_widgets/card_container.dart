import 'package:flutter/material.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/utils/color.dart';

class CardContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final double width;
  final Color? background;
  final bool enableShadow;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Clip? clipBehavior;

  const CardContainer({
    super.key,
    required this.child,
    this.height,
    this.width = double.infinity,
    this.background,
    this.enableShadow = true,
    this.padding,
    this.margin,
    this.clipBehavior,
  });

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
                    color: HexColor('0C1A4B').withValues(alpha: 0.1),
                    blurRadius: 8),
                BoxShadow(
                  color: HexColor('323247').withValues(alpha: 0.02),
                  offset: const Offset(0, 4),
                  blurRadius: 20,
                  spreadRadius: -2,
                )
              ]
            : null,
      ),
      child: child,
    );
  }
}
