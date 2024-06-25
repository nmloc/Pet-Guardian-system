import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/application/pet_service.dart';
import 'package:petcare/src/layers/presentation/common_widgets/custom_text_form_field.dart';
import 'package:petcare/src/layers/presentation/common_widgets/primary_button.dart';
import 'package:petcare/src/routing/app_router.dart';
import '../../common_widgets/appbar_with_step.dart';
import '../../common_widgets/bottom_button_area.dart';
import 'components/circle_avatar_with_effect.dart';

class APPSignsScreen extends ConsumerWidget {
  final TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppBarWithStep(
              title: 'Add Pet Profile',
              stepName: 'Signs',
              step: 7,
              totalStep: 8,
              press: () => context.pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
                child: Column(
                  children: [
                    SizedBox(height: proportionateHeight(24)),
                    // Section 1 - Avatar content
                    CircleAvatarWithEffect(
                        photoURL: ref.read(newPetProvider).photoURL),
                    SizedBox(height: proportionateHeight(24)),
                    Text(
                      "What's your pet's appearance and distinctive signs?",
                      style: AppTextStyles.bodyMedium(14, AppColors.grey800),
                    ),
                    SizedBox(height: proportionateHeight(24)),
                    customTextFormField(
                      controller: textController,
                      hintText: "Your pet's appearance and distinctive signs",
                      onTapOutside: (value) {
                        FocusScopeNode currentNode = FocusScope.of(context);
                        if (currentNode.focusedChild != null &&
                            !currentNode.hasPrimaryFocus) {
                          FocusManager.instance.primaryFocus!.unfocus();
                        }
                      },
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
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: textController,
                    builder: (context, value, __) {
                      return PrimaryButton(
                        text: 'Continue',
                        press: () {
                          ref
                              .read(newPetProvider.notifier)
                              .updateSigns(textController.text);
                          context.goNamed(AppRoute.addPetImportantDates.name);
                        },
                        enable: value.text.isNotEmpty,
                      );
                    },
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
