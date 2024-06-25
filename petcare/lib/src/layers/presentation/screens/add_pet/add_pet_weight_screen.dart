import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/application/pet_service.dart';
import 'package:petcare/src/layers/presentation/common_widgets/primary_button.dart';
import 'package:petcare/src/routing/app_router.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';
import '../../common_widgets/appbar_with_step.dart';
import '../../common_widgets/bottom_button_area.dart';
import 'components/circle_avatar_with_effect.dart';

enum MassUnits { kg, lb }

class APPWeightScreen extends ConsumerStatefulWidget {
  @override
  _APPWeightScreenState createState() => _APPWeightScreenState();
}

class _APPWeightScreenState extends ConsumerState<APPWeightScreen> {
  WeightSliderController weightController = WeightSliderController();
  double _weight = 30.0;
  MassUnits? _unit = MassUnits.kg;

  @override
  void initState() {
    super.initState();
    weightController = WeightSliderController(
        initialWeight: _weight, minWeight: 0, interval: 0.1);
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
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
              stepName: 'Weight',
              step: 6,
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
                    // Section 2 - Weight Slider
                    Text(
                      "${_weight.toStringAsFixed(1)}",
                      style: AppTextStyles.bodyBold(80, AppColors.blue500),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: proportionateHeight(50),
                          width: proportionateWidth(45),
                          decoration: BoxDecoration(
                            color: AppColors.blue500,
                            border:
                                Border.all(color: AppColors.blue700, width: 2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        VerticalWeightSlider(
                          maxWeight: 100,
                          height: proportionateHeight(70),
                          isVertical: false,
                          controller: weightController,
                          decoration: PointerDecoration(
                            width: proportionateWidth(60),
                            height: proportionateHeight(3),
                            largeColor: AppColors.grey500,
                            mediumColor: AppColors.grey500,
                            smallColor: AppColors.grey300,
                            gap: 20,
                          ),
                          onChanged: (double value) {
                            setState(() => _weight = value);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: proportionateHeight(24)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _unit = MassUnits.kg;
                            });
                          },
                          child: Ink(
                            height: proportionateHeight(50),
                            width: proportionateWidth(126.5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: _unit == MassUnits.kg
                                    ? AppColors.blue500
                                    : AppColors.grey200,
                              ),
                            ),
                            child: ListTile(
                              title: Text('kg',
                                  style: _unit == MassUnits.kg
                                      ? AppTextStyles.bodyMedium(
                                          14, AppColors.blue500)
                                      : AppTextStyles.bodyRegular(
                                          14, AppColors.grey600)),
                              leading: Radio<MassUnits>(
                                value: MassUnits.kg,
                                groupValue: _unit,
                                onChanged: (MassUnits? value) {
                                  setState(() => _unit = value);
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: proportionateWidth(14)),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _unit = MassUnits.lb;
                            });
                          },
                          child: Ink(
                            height: proportionateHeight(50),
                            width: proportionateWidth(126.5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: _unit == MassUnits.lb
                                    ? AppColors.blue500
                                    : AppColors.grey200,
                              ),
                            ),
                            child: ListTile(
                              title: Text('lb',
                                  style: _unit == MassUnits.lb
                                      ? AppTextStyles.bodyMedium(
                                          14, AppColors.blue500)
                                      : AppTextStyles.bodyRegular(
                                          14, AppColors.grey600)),
                              leading: Radio<MassUnits>(
                                value: MassUnits.lb,
                                groupValue: _unit,
                                onChanged: (MassUnits? value) {
                                  setState(() => _unit = value);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
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
                          .updateWeight(_weight.toString());
                      context.goNamed(AppRoute.addPetSigns.name);
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
