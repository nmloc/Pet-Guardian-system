import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_values.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/application/pet_service.dart';

import 'package:petcare/src/layers/domain/breed.dart';
import '../../common_widgets/bottom_button_area.dart';
import '../../common_widgets/primary_button.dart';
import 'package:petcare/src/routing/app_router.dart';

import '../../common_widgets/appbar_with_step.dart';
import 'components/breed_card.dart';

class APPBreedScreen extends ConsumerStatefulWidget {
  @override
  _APPBreedScreenState createState() => _APPBreedScreenState();
}

class _APPBreedScreenState extends ConsumerState<APPBreedScreen> {
  String searchText = '';
  int selectedIndex = 0;
  late List<Breed> breedList;

  List<Breed> filteredBreeds() => breedList
      .where((breed) =>
          breed.name.toLowerCase().contains(searchText.toLowerCase()))
      .toList();

  @override
  void initState() {
    super.initState();
    breedList =
        (ref.read(newPetProvider).species == "Canine" ? dogBreeds : catBreeds)
            .map((data) => Breed.fromJson(data))
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppBarWithStep(
              title: 'Add Pet Profile',
              stepName: 'Breed',
              step: 2,
              totalStep: 8,
              press: () => context.pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
                child: Column(
                  children: [
                    SizedBox(height: proportionateHeight(16)),
                    CupertinoSearchTextField(
                      style: AppTextStyles.bodyMedium(16, AppColors.grey600),
                      placeholder: 'Search by animal breed',
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey200),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                    ),
                    SizedBox(height: proportionateHeight(16)),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                      ),
                      shrinkWrap: true,
                      itemCount: filteredBreeds().length,
                      itemBuilder: (context, index) {
                        final breed = filteredBreeds()[index];
                        return GestureDetector(
                          onTap: () => setState(() => selectedIndex = index),
                          child: BreedCard(
                            breed: breed,
                            isSelected: selectedIndex == index,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
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
                        .updateBreed(filteredBreeds()[selectedIndex].name);
                    context.goNamed(AppRoute.addPetName.name);
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
