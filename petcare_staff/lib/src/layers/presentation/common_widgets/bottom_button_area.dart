import 'package:flutter/material.dart';
import 'package:petcare_staff/src/constants/app_colors.dart';
import 'package:petcare_staff/src/constants/app_sizes.dart';

class BottomButtonArea extends StatelessWidget {
  const BottomButtonArea({
    Key? key,
    required this.height,
    required this.child,
  }) : super(key: key);

  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            spreadRadius: 1,
            blurRadius: 3.75,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
        child: child,
      ),
    );
  }
}
