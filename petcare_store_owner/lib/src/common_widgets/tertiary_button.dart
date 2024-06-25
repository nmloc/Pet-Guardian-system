import 'package:flutter/material.dart';
import 'package:petcare_store_owner/src/constants/app_colors.dart';
import 'package:petcare_store_owner/src/constants/app_sizes.dart';
import 'package:petcare_store_owner/src/constants/app_text_styles.dart';

class TertiaryButton extends StatelessWidget {
  const TertiaryButton({
    Key? key,
    this.text,
    this.press,
  }) : super(key: key);
  final String? text;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: proportionateHeight(38),
      child: TextButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          backgroundColor: AppColors.grey0,
        ),
        onPressed: press as void Function()?,
        child:
            Text(text!, style: AppTextStyles.bodyMedium(14, AppColors.grey500)),
      ),
    );
  }
}
