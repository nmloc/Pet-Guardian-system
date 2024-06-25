import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';

class MenuCard extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Widget child;
  final VoidCallback? onTap;

  const MenuCard({
    Key? key,
    required this.title,
    required this.backgroundColor,
    required this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            alignment: Alignment.bottomRight,
            width: double.infinity,
            height: proportionateHeight(168.5),
            padding: EdgeInsets.fromLTRB(
              proportionateWidth(12),
              0,
              proportionateWidth(12),
              proportionateHeight(18),
            ),
            decoration: BoxDecoration(
              color: AppColors.grey0,
              border: Border.all(color: AppColors.grey100),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  spreadRadius: 1,
                  blurRadius: 3.75,
                ),
              ],
            ),
            child: Text(
              title,
              style: AppTextStyles.bodySemiBold(16, AppColors.grey800),
            ),
          ),
          Positioned(
            top: proportionateHeight(-30),
            child: Container(
              height: proportionateHeight(120),
              width: proportionateWidth(120),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey150),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Container(
                margin: EdgeInsets.all(proportionateHeight(20)),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          Positioned(
            top: proportionateHeight(10),
            child: child,
          ),
        ],
      ),
    );
  }
}
