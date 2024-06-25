import 'package:flutter/material.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';

class GenderCard extends StatelessWidget {
  final String gender;
  final bool isSelected;

  GenderCard({
    required this.gender,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    String photoURL;

    // Set the content based on the size
    gender == 'Male'
        ? photoURL = isSelected
            ? 'assets/icons/color-male.png'
            : 'assets/icons/grey-male.png'
        : photoURL = isSelected
            ? 'assets/icons/color-female.png'
            : 'assets/icons/grey-female.png';

    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => ProductDetail(product: product)));
      },
      child: Container(
        height: proportionateHeight(165),
        width: proportionateWidth(145),
        decoration: BoxDecoration(
          color: AppColors.grey0,
          border: isSelected
              ? gender == 'Male'
                  ? Border.all(color: AppColors.blue500, width: 2)
                  : Border.all(color: AppColors.magenta300, width: 2)
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
            Text(gender,
                style: isSelected
                    ? gender == 'Male'
                        ? AppTextStyles.bodySemiBold(16, AppColors.blue500)
                        : AppTextStyles.bodySemiBold(16, AppColors.magenta500)
                    : AppTextStyles.bodySemiBold(14, AppColors.grey800)),
          ],
        ),
      ),
    );
  }
}
