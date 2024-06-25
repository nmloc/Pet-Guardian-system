// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/application/pet_service.dart';
import 'package:petcare/src/layers/presentation/common_widgets/primary_button.dart';
import 'package:petcare/src/routing/app_router.dart';

import '../../common_widgets/appbar_with_step.dart';
import '../../common_widgets/bottom_button_area.dart';
import '../../common_widgets/custom_text_form_field.dart';

class APPNameScreen extends ConsumerWidget {
  TextEditingController textController = TextEditingController();
  XFile? pickedImage;

  Future<void> pickImage(ImageSource source) async {
    try {
      pickedImage = await ImagePicker().pickImage(
        source: source,
        imageQuality: 100,
      );
    } catch (e) {
      print('Pick image error: $e');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String _photoURL =
        ref.watch(newPetProvider.select((newPet) => newPet.photoURL));

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppBarWithStep(
              title: 'Add Pet Profile',
              stepName: 'Name',
              step: 3,
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

                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          padding: EdgeInsets.all(proportionateHeight(27)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(186),
                              border: Border.all(color: AppColors.grey150)),
                          child: Container(
                            padding: EdgeInsets.all(proportionateHeight(20)),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(186),
                                border: Border.all(color: AppColors.grey150)),
                            child: CircleAvatar(
                              radius: proportionateWidth(93),
                              backgroundImage: _photoURL == ''
                                  ? ref.read(newPetProvider).species == 'Canine'
                                      ? const AssetImage(
                                          'assets/images/dog-default-avatar.png')
                                      : const AssetImage(
                                              'assets/images/cat-default-avatar.jpg')
                                          as ImageProvider<Object>
                                  : FileImage(File(_photoURL)),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: proportionateHeight(25),
                          child: GestureDetector(
                            onTap: () {
                              pickImage(ImageSource.gallery).then(
                                (_) => ref
                                    .read(newPetProvider.notifier)
                                    .updateImage(pickedImage!.path),
                              );
                            },
                            child: Image.asset(
                              'assets/icons/change-pet-avatar.png',
                              width: proportionateWidth(46),
                              height: proportionateHeight(46),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: proportionateHeight(24)),
                    // Section 2 - Pet's name text field
                    Text(
                      "What's your pet's name?",
                      style: AppTextStyles.bodyMedium(14, AppColors.grey800),
                    ),
                    SizedBox(height: proportionateHeight(16)),
                    customTextFormField(
                      controller: textController,
                      hintText: "Your pet's name",
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
                              .updateName(textController.text);
                          context.goNamed(AppRoute.addPetGender.name);
                        },
                        enable: _photoURL != '' && value.text.isNotEmpty,
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
