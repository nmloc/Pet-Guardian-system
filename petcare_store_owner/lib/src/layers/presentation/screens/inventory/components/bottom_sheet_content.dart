import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petcare_store_owner/src/common_widgets/primary_button.dart';
import 'package:petcare_store_owner/src/constants/app_colors.dart';
import 'package:petcare_store_owner/src/constants/app_sizes.dart';
import 'package:petcare_store_owner/src/constants/app_text_styles.dart';
import 'package:petcare_store_owner/src/layers/data/vaccine_repository.dart';
import 'package:petcare_store_owner/src/layers/domain/vaccine.dart';

List<String> _speciesList = ['Canine', 'Feline', 'Both'];

// ignore: must_be_immutable
class BottomSheetContent extends ConsumerWidget {
  final imageProvider = StateProvider.autoDispose<XFile?>((ref) => null);
  final speciesProvider =
      StateProvider.autoDispose<String>((ref) => _speciesList[0]);
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController manufacturerController = TextEditingController();
  TextEditingController primaryDosesController = TextEditingController();
  TextEditingController repeatIntervalController = TextEditingController();
  TextEditingController validIntervalController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController speciesController = TextEditingController();

  String category;

  BottomSheetContent(this.category, {super.key});

  String? validate(String? value, {bool isNumberOnly = false}) {
    if (value == null || value.isEmpty) {
      return 'Required information';
    }
    if (isNumberOnly) {
      if (num.tryParse(value) == null) {
        return 'Please enter a valid number';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _image = ref.watch(imageProvider);

    Future<void> pickImage(ImageSource source) async {
      try {
        ref.read(imageProvider.notifier).state = await ImagePicker().pickImage(
          source: source,
          imageQuality: 100,
        );
      } catch (e) {
        print('Pick image error: $e');
      }
    }

    void _showDialog(Widget child) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(
            top: false,
            child: child,
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: proportionateHeight(70),
              padding: EdgeInsets.symmetric(horizontal: proportionateWidth(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Add $category',
                      style: AppTextStyles.titleBold(30, AppColors.grey900),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerRight,
                      onPressed: () => context.pop(),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.grey150,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Icon(
                          CupertinoIcons.clear,
                          size: 20,
                          color: AppColors.grey700,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Divider(height: 0.5, thickness: 0.5, color: AppColors.grey200),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: AppColors.grey0),
                      child: CupertinoButton(
                          child: Container(
                            height: proportionateHeight(180),
                            width: proportionateWidth(180),
                            decoration: BoxDecoration(
                              color: AppColors.grey150,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: _image == null
                                ? Icon(
                                    CupertinoIcons.cloud_upload_fill,
                                    color: AppColors.grey900,
                                  )
                                : Image.file(
                                    File(_image.path),
                                    fit: BoxFit.fill,
                                  ),
                          ),
                          onPressed: () => pickImage(ImageSource.gallery)),
                    ),
                    CupertinoListSection(
                      topMargin: 0,
                      margin: EdgeInsets.zero,
                      hasLeading: false,
                      children: [
                        CupertinoTextFormFieldRow(
                          controller: nameController,
                          textAlign: TextAlign.end,
                          prefix: const Text('Name'),
                          placeholder: 'Name',
                          validator: validate,
                        ),
                        if (category == 'Vaccine')
                          CupertinoTextFormFieldRow(
                            controller: descriptionController,
                            textAlign: TextAlign.end,
                            prefix: const Text('Description'),
                            placeholder: 'Description',
                            maxLines: null,
                            expands: true,
                            validator: validate,
                          ),
                        if (category == 'Vaccine')
                          CupertinoTextFormFieldRow(
                            controller: manufacturerController,
                            textAlign: TextAlign.end,
                            prefix: const Text('Manufacturer'),
                            placeholder: 'Manufacturer',
                            validator: validate,
                          ),
                        if (category == 'Vaccine')
                          CupertinoTextFormFieldRow(
                            controller: primaryDosesController,
                            textAlign: TextAlign.end,
                            prefix: const Text('Primary Doses'),
                            placeholder: 'Number of Doses',
                            validator: (value) =>
                                validate(value, isNumberOnly: true),
                          ),
                        if (category == 'Vaccine')
                          ValueListenableBuilder(
                            valueListenable: primaryDosesController,
                            builder: (context, value, _) {
                              if (primaryDosesController.text.isNotEmpty) {
                                if (int.parse(primaryDosesController.text) >
                                    1) {
                                  return CupertinoTextFormFieldRow(
                                    controller: repeatIntervalController,
                                    textAlign: TextAlign.end,
                                    prefix: const Text('Repeat Interval'),
                                    placeholder: 'Number of Weeks',
                                    validator: (value) =>
                                        validate(value, isNumberOnly: true),
                                  );
                                }
                              }
                              return Container();
                            },
                          ),
                        if (category == 'Vaccine')
                          CupertinoTextFormFieldRow(
                            controller: validIntervalController,
                            textAlign: TextAlign.end,
                            prefix: const Text('Valid Interval'),
                            placeholder: 'Number of Months',
                            validator: (value) =>
                                validate(value, isNumberOnly: true),
                          ),
                        CupertinoTextFormFieldRow(
                          controller: priceController,
                          textAlign: TextAlign.end,
                          prefix: const Text('Price'),
                          placeholder: 'in VND',
                          validator: (value) =>
                              validate(value, isNumberOnly: true),
                        ),
                        CupertinoButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Species',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: CupertinoColors.black,
                                ),
                              ),
                              Text(
                                ref.watch(speciesProvider),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: CupertinoColors.black,
                                ),
                              )
                            ],
                          ),
                          onPressed: () => _showDialog(
                            CupertinoPicker(
                                magnification: 1.22,
                                squeeze: 1.2,
                                useMagnifier: true,
                                itemExtent: 32,
                                onSelectedItemChanged: (int index) => ref
                                    .read(speciesProvider.notifier)
                                    .state = _speciesList[index],
                                children: _speciesList
                                    .map((value) => Center(child: Text(value)))
                                    .toList()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
              child: PrimaryButton(
                text: 'Confirm',
                press: () async {
                  if (category == 'Insurance') {
                    // await ref.read(insuranceRepositoryProvider).createPack(
                    //     InsurancePack(
                    //         id: '',
                    //         name: nameController.text,
                    //         price: int.parse(priceController.text),
                    //         species: speciesController.text,
                    //         details: detials));
                  } else if (category == 'Vaccine') {
                    await ref
                        .read(vaccineRepositoryProvider)
                        .createVaccine(
                          Vaccine(
                            id: '',
                            name: nameController.text,
                            manufacturer: manufacturerController.text,
                            species: ref.read(speciesProvider) != 'Both'
                                ? [ref.read(speciesProvider)]
                                : ['Canine', 'Feline'],
                            description: descriptionController.text
                                .split(RegExp(r'\r?\n'))
                                .where((line) => line.trim().isNotEmpty)
                                .toList(),
                            primaryDoses:
                                int.parse(primaryDosesController.text),
                            repeatDoseWeek:
                                repeatIntervalController.text.isNotEmpty
                                    ? int.parse(repeatIntervalController.text)
                                    : 0,
                            validMonth: int.parse(validIntervalController.text),
                            price: int.parse(priceController.text),
                            photoURL: _image!.path,
                          ),
                        )
                        .then((_) {
                      context.pop();
                      Fluttertoast.showToast(
                          msg:
                              '$category ${nameController.text} created successfully.',
                          timeInSecForIosWeb: 4);
                    });
                  }
                },
                enable: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
