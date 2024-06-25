import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/utils/color.dart';
import 'package:petcare/src/layers/domain/insurance_pack.dart';
import 'package:petcare/src/utils/int.dart';

class PackCard extends StatelessWidget {
  const PackCard({
    Key? key,
    required this.pack,
    this.isSelected = false,
  }) : super(key: key);

  final InsurancePack pack;
  final bool isSelected;

  String getPackIcon() {
    if (pack.name == 'Basic Pack') {
      return isSelected
          ? 'assets/icons/umbrella-blue.svg'
          : 'assets/icons/umbrella-grey.svg';
    } else if (pack.name == 'Comfy Pack') {
      return isSelected
          ? 'assets/icons/shield-blue.svg'
          : 'assets/icons/shield-grey.svg';
    } else if (pack.name == 'King Pack') {
      return isSelected
          ? 'assets/icons/crown-blue.svg'
          : 'assets/icons/crown-grey.svg';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: isSelected
          ? EdgeInsets.all(0)
          : EdgeInsets.symmetric(horizontal: proportionateWidth(13.5)),
      height: isSelected ? proportionateHeight(104) : proportionateHeight(70),
      padding: EdgeInsets.symmetric(horizontal: proportionateWidth(16)),
      decoration: isSelected
          ? BoxDecoration(
              color: AppColors.grey0,
              border: Border.all(color: AppColors.blue500),
              borderRadius: BorderRadius.circular(14),
            )
          : BoxDecoration(
              color: AppColors.grey0,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: HexColor('0C1A4B').withOpacity(0.08),
                  blurRadius: 5,
                ),
                BoxShadow(
                  color: HexColor('323247').withOpacity(0.04),
                  blurRadius: 20,
                  spreadRadius: -2,
                  offset: Offset(0, 4),
                ),
              ],
            ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: isSelected
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blue500.withOpacity(0.07),
                        spreadRadius: 27,
                      ),
                      BoxShadow(
                        color: AppColors.blue500.withOpacity(0.05),
                        spreadRadius: 42,
                      ),
                      BoxShadow(
                        color: AppColors.blue500.withOpacity(0.07),
                        spreadRadius: 52,
                      ),
                    ],
                  )
                : BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.grey900.withOpacity(0.02),
                        spreadRadius: 17,
                      ),
                      BoxShadow(
                        color: AppColors.grey700.withOpacity(0.04),
                        spreadRadius: 27,
                      ),
                      BoxShadow(
                        color: AppColors.grey500.withOpacity(0.07),
                        spreadRadius: 34,
                      ),
                    ],
                  ),
            child: isSelected
                ? SvgPicture.asset(
                    getPackIcon(),
                    height: proportionateHeight(27),
                    width: proportionateWidth(27),
                  )
                : SvgPicture.asset(
                    getPackIcon(),
                    height: proportionateHeight(17),
                    width: proportionateWidth(17),
                  ),
          ),
          isSelected ? SizedBox(width: proportionateWidth(25)) : Container(),
          Text(
            pack.name,
            style: isSelected
                ? AppTextStyles.bodySemiBold(16, AppColors.blue500)
                : AppTextStyles.bodySemiBold(14, AppColors.grey800),
          ),
          Row(
            children: [
              Text(
                pack.price.formatPrice(),
                style: AppTextStyles.bodySemiBold(16, AppColors.grey900),
              ),
              Text(
                " VND",
                style: AppTextStyles.bodyRegular(12, AppColors.grey900),
              ),
              Text(
                '/month',
                style: AppTextStyles.bodyRegular(12, AppColors.grey600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
