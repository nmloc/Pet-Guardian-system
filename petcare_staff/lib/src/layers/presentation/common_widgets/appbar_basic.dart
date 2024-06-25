import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare_staff/src/constants/app_colors.dart';
import 'package:petcare_staff/src/constants/app_sizes.dart';
import 'package:petcare_staff/src/constants/app_text_styles.dart';

class BasicAppBar extends StatelessWidget {
  const BasicAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: proportionateWidth(12), right: proportionateWidth(24)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.only(left: proportionateWidth(12)),
                alignment: Alignment.center,
                height: proportionateHeight(40),
                child: Text(title,
                    style: AppTextStyles.titleBold(18, AppColors.grey800)),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  alignment: Alignment.centerLeft,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.grey600,
                    size: 20,
                  ),
                  onPressed: () => context.pop(),
                ),
              ),
            ],
          ),
          // SizedBox(height: proportionateHeight(10)),

          // Custom fade out divider
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.transparent,
                  AppColors.radial,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
