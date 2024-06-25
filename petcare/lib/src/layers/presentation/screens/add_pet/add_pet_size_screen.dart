import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/constants/app_values.dart';
import 'package:petcare/src/layers/application/pet_service.dart';

import 'package:petcare/src/layers/presentation/screens/add_pet/components/size_card.dart';
import 'package:petcare/src/layers/presentation/common_widgets/appbar_with_step.dart';
import 'package:petcare/src/layers/presentation/common_widgets/primary_button.dart';
import 'package:petcare/src/routing/app_router.dart';

import '../../common_widgets/bottom_button_area.dart';
import 'components/circle_avatar_with_effect.dart';

class APPSizeScreen extends ConsumerStatefulWidget {
  static String routeName = "/add_pet_profile_size";

  @override
  _APPSizeScreenState createState() => _APPSizeScreenState();
}

class _APPSizeScreenState extends ConsumerState<APPSizeScreen> {
  int selectedIndex = 1;
  CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppBarWithStep(
              title: 'Add Pet Profile',
              stepName: 'Size',
              step: 5,
              totalStep: 8,
              press: () => context.pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: proportionateHeight(24)),
                    // Section 1 - Avatar content
                    CircleAvatarWithEffect(
                        photoURL: ref.read(newPetProvider).photoURL),
                    SizedBox(height: proportionateHeight(24)),
                    Text(
                      "What's your pet's size?",
                      style: AppTextStyles.bodyMedium(14, AppColors.grey800),
                    ),
                    SizedBox(height: proportionateHeight(4)),
                    Text(
                      "Automatic selection based on your pets breed.",
                      style: AppTextStyles.bodyRegular(12, AppColors.grey700),
                    ),
                    Text(
                      "Adjust according to reality",
                      style: AppTextStyles.bodyRegular(12, AppColors.grey700),
                    ),
                    SizedBox(height: proportionateHeight(24)),
                    // Section 2 - Size Slider
                    CarouselSlider(
                      carouselController: carouselController,
                      options: CarouselOptions(
                        height: proportionateHeight(165),
                        viewportFraction: 0.4,
                        initialPage: 1,
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() => selectedIndex = index);
                        },
                      ),
                      items: List.generate(
                        sizeList.length,
                        (index) => SizeCard(
                          size: sizeList[index],
                          isSelected: index == selectedIndex,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Section 3 - Bottom Buttons Area
            BottomButtonArea(
              height: proportionateHeight(112),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrimaryButton(
                    text: 'Continue',
                    press: () {
                      ref
                          .read(newPetProvider.notifier)
                          .updateSize(sizeList[selectedIndex]);
                      context.goNamed(AppRoute.addPetWeight.name);
                    },
                    enable: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
