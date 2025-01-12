import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/constants/app_values.dart';
import 'package:petcare/src/layers/application/pet_service.dart';

import 'package:petcare/src/layers/presentation/common_widgets/appbar_with_step.dart';
import 'package:petcare/src/layers/presentation/common_widgets/primary_button.dart';
import 'package:petcare/src/routing/app_router.dart';

import '../../common_widgets/bottom_button_area.dart';
import 'components/gender_card.dart';

class APPGenderScreen extends ConsumerStatefulWidget {
  @override
  _APPGenderScreenState createState() => _APPGenderScreenState();
}

class _APPGenderScreenState extends ConsumerState<APPGenderScreen> {
  int selectedIndex = 0;
  CarouselSliderController carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppBarWithStep(
              title: 'Add Pet Profile',
              stepName: 'Gender',
              step: 4,
              totalStep: 8,
              press: () => context.pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: proportionateHeight(24)),
                    Text(
                      "What's your pet's gender?",
                      style: AppTextStyles.bodyMedium(14, AppColors.grey800),
                    ),
                    SizedBox(height: proportionateHeight(24)),
                    // Section 2 - Size Slider
                    CarouselSlider(
                      carouselController: carouselController,
                      options: CarouselOptions(
                        height: proportionateHeight(165),
                        viewportFraction: 0.4,
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) =>
                            setState(() => selectedIndex = index),
                      ),
                      items: List.generate(
                        genderList.length,
                        (index) => GenderCard(
                          gender: genderList[index],
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
                          .updateGender(genderList[selectedIndex]);
                      context.goNamed(AppRoute.addPetSize.name);
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
