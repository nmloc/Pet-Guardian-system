import 'package:flutter/material.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';

TextFormField customTextFormField(
        {required TextEditingController controller,
        required String hintText,
        required void Function(PointerDownEvent) onTapOutside}) =>
    TextFormField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: proportionateWidth(16),
          vertical: proportionateHeight(18),
        ),
        hintText: hintText,
        hintStyle: AppTextStyles.bodyRegular(16, AppColors.grey600),
      ),
      textCapitalization: TextCapitalization.words,
      style: AppTextStyles.bodyMedium(16, AppColors.grey800),
      cursorColor: AppColors.grey800,
      autocorrect: false,
      onTapOutside: onTapOutside,
    );
