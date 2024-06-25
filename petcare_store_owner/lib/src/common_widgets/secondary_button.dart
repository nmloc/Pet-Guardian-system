import 'package:flutter/material.dart';
import 'package:petcare_store_owner/src/constants/app_colors.dart';
import 'package:petcare_store_owner/src/constants/app_sizes.dart';
import 'package:petcare_store_owner/src/constants/app_text_styles.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    Key? key,
    this.iconData,
    required this.text,
    required this.press,
  }) : super(key: key);
  final IconData? iconData;
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey0,
        border: Border.all(color: AppColors.blue500),
        borderRadius: BorderRadius.circular(14),
      ),
      width: double.infinity,
      height: proportionateHeight(54),
      child: TextButton(
        onPressed: press as void Function(),
        child: iconData == null
            ? Text(
                text,
                style: AppTextStyles.bodyMedium(14, AppColors.blue500),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconData,
                    size: 20,
                    color: AppColors.blue500,
                  ),
                  SizedBox(width: proportionateWidth(6)),
                  Text(
                    text,
                    style: AppTextStyles.bodyMedium(14, AppColors.blue500),
                  ),
                ],
              ),
      ),
    );
  }
}
