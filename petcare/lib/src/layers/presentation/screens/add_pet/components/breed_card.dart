import 'package:flutter/material.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/domain/breed.dart';

class BreedCard extends StatelessWidget {
  final Breed breed;
  final bool isSelected;

  BreedCard({
    required this.breed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: proportionateHeight(155),
      width: proportionateWidth(155),
      decoration: BoxDecoration(
        color: AppColors.grey0,
        border: isSelected
            ? Border.all(color: AppColors.blue500, width: 2)
            : Border.all(color: AppColors.grey150),
        borderRadius: isSelected
            ? const BorderRadius.all(Radius.circular(19.25))
            : const BorderRadius.all(Radius.circular(14)),
        boxShadow: [
          isSelected
              ? BoxShadow(color: AppColors.blue500)
              : BoxShadow(
                  color: AppColors.shadow,
                  spreadRadius: 1,
                  blurRadius: 3.75,
                ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(breed.name,
              style: isSelected
                  ? AppTextStyles.bodySemiBold(14, AppColors.blue500)
                  : AppTextStyles.bodySemiBold(14, AppColors.grey800)),
          SizedBox(height: proportionateHeight(10)),
          SizedBox(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  width: proportionateWidth(125),
                  height: proportionateHeight(62),
                  child: Image.asset(
                    'assets/images/breed_card_background.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: proportionateWidth(87),
                  height: proportionateHeight(87),
                  child: Image.asset(
                    breed.photoURL,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
