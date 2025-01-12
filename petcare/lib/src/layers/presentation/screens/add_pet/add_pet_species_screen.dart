import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/constants/app_values.dart';
import 'package:petcare/src/layers/application/pet_service.dart';
import 'package:petcare/src/layers/presentation/screens/add_pet/components/species_card.dart';
import 'package:petcare/src/layers/presentation/common_widgets/appbar_with_step.dart';
import 'package:petcare/src/layers/presentation/common_widgets/primary_button.dart';
import 'package:petcare/src/routing/app_router.dart';

import '../../common_widgets/bottom_button_area.dart';

class APPSpeciesScreen extends ConsumerStatefulWidget {
  static String routeName = "/add_pet_profile_species";

  @override
  _APPSpeciesScreenState createState() => _APPSpeciesScreenState();
}

class _APPSpeciesScreenState extends ConsumerState<APPSpeciesScreen> {
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
              stepName: 'Species',
              step: 1,
              totalStep: 8,
              press: () {
                ref.invalidate(newPetProvider);
                context.pop();
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: proportionateHeight(24)),
                    Text(
                      "What's your pet's species?",
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
                        onPageChanged: (index, reason) {
                          setState(() => selectedIndex = index);
                        },
                      ),
                      items: List.generate(
                        speciesList.length,
                        (index) => SpeciesCard(
                          species: speciesList[index],
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
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: proportionateHeight(24)),
                child: PrimaryButton(
                  text: 'Continue',
                  press: () {
                    ref
                        .read(newPetProvider.notifier)
                        .updateSpecies(speciesList[selectedIndex]);
                    context.goNamed(AppRoute.addPetBreed.name);
                  },
                  enable: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
