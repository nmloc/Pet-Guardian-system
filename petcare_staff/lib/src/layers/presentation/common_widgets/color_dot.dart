import 'package:flutter/material.dart';
import 'package:petcare_staff/src/constants/app_sizes.dart';

class ColorDot extends StatelessWidget {
  final Color color;
  final double radius;
  const ColorDot(this.color, this.radius, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: proportionateHeight(radius * 2),
      width: proportionateWidth(radius * 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}
