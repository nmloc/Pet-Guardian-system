import 'package:flutter/material.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';

class SpeciesCard extends StatelessWidget {
  final String species;
  final bool isSelected;

  SpeciesCard({
    required this.species,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    String photoURL;

    // Set the content based on the size
    species == 'Canine'
        ? photoURL = isSelected
            ? 'assets/icons/color-dog.png'
            : 'assets/icons/black-dog.png'
        : photoURL = isSelected
            ? 'assets/icons/color-cat.png'
            : 'assets/icons/black-cat.png';

    return Container(
      height: proportionateHeight(165),
      width: proportionateWidth(145),
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
                  color: AppColors.grey150,
                  spreadRadius: 1,
                  blurRadius: 3.75,
                ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            photoURL,
            width: proportionateWidth(55),
          ),
          SizedBox(height: proportionateHeight(10)),
          Text(species,
              style: isSelected
                  ? AppTextStyles.bodySemiBold(16, AppColors.blue500)
                  : AppTextStyles.bodySemiBold(14, AppColors.grey800)),
        ],
      ),
    );
  }
}
