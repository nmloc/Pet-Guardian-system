// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:petcare_staff/src/common_widgets/primary_button.dart';
// import 'package:petcare_staff/src/constants/app_colors.dart';
// import 'package:petcare_staff/src/constants/app_sizes.dart';
// import 'package:petcare_staff/src/constants/app_text_styles.dart';
// import 'package:petcare_staff/src/layers/data/insurance_repository.dart';
// import 'package:petcare_staff/src/layers/data/vaccine_repository.dart';
// import 'package:petcare_staff/src/layers/domain/insurance_pack.dart';
// import 'package:petcare_staff/src/layers/domain/vaccine.dart';

// final imageProvider = StateProvider.autoDispose<XFile?>((ref) => null);

// // ignore: must_be_immutable
// class BottomSheetContent extends ConsumerWidget {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//   TextEditingController manufacturerController = TextEditingController();
//   TextEditingController primaryDosesController = TextEditingController();
//   TextEditingController repeatIntervalController = TextEditingController();
//   TextEditingController priceController = TextEditingController();
//   TextEditingController speciesController = TextEditingController();

//   String category;

//   BottomSheetContent(this.category, {super.key});

//   String? validate(String? value, {bool isNumberOnly = false}) {
//     if (value == null || value.isEmpty) {
//       return 'Required information';
//     }
//     if (isNumberOnly) {
//       if (num.tryParse(value) == null) {
//         return 'Please enter a valid number';
//       }
//     }

//     return null;
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final _image = ref.watch(imageProvider);

//     Future<void> pickImage(ImageSource source) async {
//       try {
//         ref.read(imageProvider.notifier).state = await ImagePicker().pickImage(
//           source: source,
//           imageQuality: 100,
//         );
//       } catch (e) {
//         print('Pick image error: $e');
//       }
//     }

//     return SafeArea(
//       child: Column(
//         children: [
//           Container(
//             height: proportionateHeight(70),
//             padding: EdgeInsets.symmetric(horizontal: proportionateWidth(12)),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Align(
//                   alignment: Alignment.bottomLeft,
//                   child: Text(
//                     'Add $category',
//                     style: AppTextStyles.titleBold(30, AppColors.grey900),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.topRight,
//                   child: CupertinoButton(
//                     padding: EdgeInsets.zero,
//                     alignment: Alignment.centerRight,
//                     onPressed: () => context.pop(),
//                     child: Container(
//                       padding: const EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         color: AppColors.grey150,
//                         borderRadius: BorderRadius.circular(100),
//                       ),
//                       child: Icon(
//                         CupertinoIcons.clear,
//                         size: 20,
//                         color: AppColors.grey700,
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Divider(height: 0.5, thickness: 0.5, color: AppColors.grey200),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(color: AppColors.grey0),
//                     child: CupertinoButton(
//                         child: Container(
//                           height: proportionateHeight(180),
//                           width: proportionateWidth(180),
//                           decoration: BoxDecoration(
//                             color: AppColors.grey150,
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           child: _image == null
//                               ? Icon(
//                                   CupertinoIcons.cloud_upload_fill,
//                                   color: AppColors.grey900,
//                                 )
//                               : Image.file(
//                                   File(_image.path),
//                                   fit: BoxFit.fill,
//                                 ),
//                         ),
//                         onPressed: () => pickImage(ImageSource.gallery)),
//                   ),
//                   CupertinoListSection(
//                     topMargin: 0,
//                     margin: EdgeInsets.zero,
//                     hasLeading: false,
//                     children: [
//                       CupertinoTextFormFieldRow(
//                         controller: nameController,
//                         textAlign: TextAlign.end,
//                         prefix: const Text('Name'),
//                         placeholder: 'Name',
//                         validator: validate,
//                       ),
//                       if (category == 'Vaccine')
//                         CupertinoTextFormFieldRow(
//                           controller: descriptionController,
//                           textAlign: TextAlign.end,
//                           prefix: const Text('Description'),
//                           placeholder: 'Description',
//                           maxLines: null,
//                           expands: true,
//                           validator: validate,
//                         ),
//                       if (category == 'Vaccine')
//                         CupertinoTextFormFieldRow(
//                           controller: manufacturerController,
//                           textAlign: TextAlign.end,
//                           prefix: const Text('Manufacturer'),
//                           placeholder: 'Manufacturer',
//                           validator: validate,
//                         ),
//                       if (category == 'Vaccine')
//                         CupertinoTextFormFieldRow(
//                           controller: primaryDosesController,
//                           textAlign: TextAlign.end,
//                           prefix: const Text('Primary Doses'),
//                           placeholder: 'Number of Doses',
//                           validator: (value) =>
//                               validate(value, isNumberOnly: true),
//                         ),
//                       if (category == 'Vaccine')
//                         CupertinoTextFormFieldRow(
//                           controller: repeatIntervalController,
//                           textAlign: TextAlign.end,
//                           prefix: const Text('Vaccine Repeat Interval'),
//                           placeholder: 'Number of Weeks',
//                           validator: (value) =>
//                               validate(value, isNumberOnly: true),
//                         ),
//                       CupertinoTextFormFieldRow(
//                         controller: priceController,
//                         textAlign: TextAlign.end,
//                         prefix: const Text('Price'),
//                         placeholder: 'in VND',
//                         validator: (value) =>
//                             validate(value, isNumberOnly: true),
//                       ),
//                       CupertinoTextFormFieldRow(
//                         controller: speciesController,
//                         textAlign: TextAlign.end,
//                         prefix: const Text('Species'),
//                         placeholder: 'Canine or Feline',
//                         validator: validate,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
//             child: PrimaryButton(
//               text: 'Confirm',
//               press: () async {
//                 if (category == 'Insurance') {
//                   await ref.read(insuranceRepositoryProvider).createPack(
//                       InsurancePack(

//                           name: nameController.text,
//                           price: int.parse(priceController.text),
//                           species: speciesController.text,
//                           details: details));
//                 } else if (category == 'Vaccine') {
//                   await ref.read(vaccineRepositoryProvider).uploadPhoto(id, photoPath) ref.read(vaccineRepositoryProvider).createVaccine(
//                       Vaccine(
//                           id: '',
//                           name: nameController.text,
//                           manufacturer: manufacturerController.text,
//                           species: speciesController.text,
//                           description: description,
//                           primaryDoses: int.parse(primaryDosesController.text),
//                           repeatDoseWeek:
//                               int.parse(repeatIntervalController.text),
//                           validMonth: validMonth,
//                           sellingPrice: int.parse(priceController.text),
//                           photoURL: photoURL));
//                 }
//               },
//               enable: true,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
