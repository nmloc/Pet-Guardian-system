import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petcare_staff/src/constants/app_colors.dart';
import 'package:petcare_staff/src/constants/app_sizes.dart';
import 'package:petcare_staff/src/constants/app_text_styles.dart';

class MenuCard extends StatelessWidget {
  final String title;
  final String? value;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  const MenuCard({
    Key? key,
    required this.title,
    this.value,
    required this.color,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  Color backgroundColor() {
    if (color == AppColors.blue500) {
      return AppColors.blue100;
    } else if (color == AppColors.green500) {
      return AppColors.green100;
    } else if (color == AppColors.purple500) {
      return AppColors.purple100;
    } else {
      return AppColors.orange100;
    }
  }

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (value != null && value != '')
                  Text(
                    value!,
                    style: AppTextStyles.bodySemiBold(20, color),
                  ),
                Text(
                  title,
                  style: AppTextStyles.bodySemiBold(16, AppColors.grey800),
                ),
              ],
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
                  color: backgroundColor(),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          Positioned(
            top: proportionateHeight(24),
            child: FaIcon(
              icon,
              size: 61,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
