import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/presentation/screens/dashboard/components/dashboard_appbar.dart';
import 'package:petcare/src/routing/app_router.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
      child: Column(
        children: [
          const DashboardAppBar(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: proportionateHeight(210),
                  width: proportionateWidth(225),
                  child: Image.asset(
                      'assets/images/empty_dashboard_background.png'),
                ),
                SizedBox(height: proportionateHeight(32)),
                Text(
                  'Uh Oh!',
                  style: AppTextStyles.titleBold(26, AppColors.grey800),
                ),
                SizedBox(height: proportionateHeight(10)),
                Text(
                  'Looks like you have no profiles set up at this moment, add your pet now',
                  style: AppTextStyles.bodyMedium(16, AppColors.grey600),
                  textAlign: TextAlign.center,
                  maxLines: 5,
                ),
              ],
            ),
          ),
          SwipeButton(
            thumb: const Icon(
              Icons.keyboard_double_arrow_right_rounded,
              color: Colors.white,
            ),
            activeThumbColor: AppColors.blue500,
            activeTrackColor: AppColors.blue100,
            borderRadius: const BorderRadius.all(Radius.circular(18)),
            height: proportionateHeight(54),
            thumbPadding: const EdgeInsets.all(6),
            child: Text(
              "Swipe to continue",
              style: AppTextStyles.bodySemiBold(14, AppColors.blue500),
            ),
            onSwipeEnd: () => context.goNamed(AppRoute.addPetSpecies.name),
          ),
        ],
      ),
    );
  }
}
