import 'package:flutter/material.dart';
import 'package:petcare_store_owner/src/constants/app_colors.dart';
import 'package:petcare_store_owner/src/constants/app_sizes.dart';
import 'package:petcare_store_owner/src/constants/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    required this.text,
    required this.press,
    required this.enable,
    this.background,
  }) : super(key: key);
  final String text;
  final VoidCallback press;
  final bool enable;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: proportionateHeight(54),
      child: TextButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          backgroundColor:
              enable ? background ?? AppColors.blue500 : AppColors.blue100,
        ),
        onPressed: enable ? press : null,
        child: Text(text, style: AppTextStyles.bodyMedium(14, AppColors.grey0)),
      ),
    );
  }
}
