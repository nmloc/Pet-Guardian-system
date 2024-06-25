import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';

class SizeCard extends StatelessWidget {
  final String size;
  final bool isSelected;

  SizeCard({
    required this.size,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    String photoURL;
    String description;

    // Set the content based on the size
    if (size == 'Small') {
      photoURL = isSelected
          ? 'assets/icons/selected-small-size-pet.svg'
          : 'assets/icons/unselected-small-size-pet.svg';
      description = 'under 14kg';
    } else if (size == 'Medium') {
      photoURL = isSelected
          ? 'assets/icons/selected-medium-size-pet.svg'
          : 'assets/icons/unselected-medium-size-pet.svg';

      description = '14-25kg';
    } else if (size == 'Large') {
      photoURL = isSelected
          ? 'assets/icons/selected-large-size-pet.svg'
          : 'assets/icons/unselected-large-size-pet.svg';

      description = 'over 25kg';
    } else {
      // Handle other cases or provide a default value
      photoURL = 'assets/icons/unselected-medium-size-pet.svg';

      description = 'Unknown';
    }

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
            SvgPicture.asset(
              photoURL,
              width: proportionateWidth(55),
            ),
            SizedBox(height: proportionateHeight(10)),
            Text(size,
                style: isSelected
                    ? AppTextStyles.bodySemiBold(16, AppColors.blue500)
                    : AppTextStyles.bodySemiBold(14, AppColors.grey800)),
            Text(description,
                style: isSelected
                    ? AppTextStyles.bodyRegular(14, AppColors.blue300)
                    : AppTextStyles.bodyRegular(12, AppColors.grey600)),
          ],
        ),
      ),
    );
  }
}
