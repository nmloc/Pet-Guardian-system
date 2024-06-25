import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/constants/app_values.dart';
import 'package:petcare/src/layers/data/pet_repository.dart';
import 'package:petcare/src/layers/domain/pet.dart';
import 'package:petcare/src/layers/presentation/common_widgets/appbar_basic.dart';
import 'package:petcare/src/layers/presentation/common_widgets/primary_button.dart';
import 'package:petcare/src/utils/datetime.dart';

List<String> weightList = List.generate(51, (index) => index.toString());

void showDialog(Widget child, BuildContext context) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(28),
      ),
      height: proportionateHeight(280),
      child: SafeArea(
        top: false,
        child: child,
      ),
    ),
  );
}

class EditPetProfileScreen extends ConsumerStatefulWidget {
  final Pet pet;
  const EditPetProfileScreen({
    Key? key,
    required this.pet,
  }) : super(key: key);

  @override
  _EditPetProfileScreenState createState() => _EditPetProfileScreenState();
}

class _EditPetProfileScreenState extends ConsumerState<EditPetProfileScreen> {
  final imageProvider = StateProvider<XFile?>((ref) => null);
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController signsTextController = TextEditingController();
  late StateProvider<String> speciesProvider;
  late StateProvider<String> breedProvider;
  late StateProvider<String> genderProvider;
  late StateProvider<String> sizeProvider;
  late StateProvider<String> weightProvider;
  late StateProvider<DateTime> birthDateProvider;
  late StateProvider<DateTime> adoptionDateProvider;

  @override
  void initState() {
    super.initState();
    nameTextController.text = widget.pet.name;
    signsTextController.text = widget.pet.signs;
    speciesProvider = StateProvider<String>((ref) => widget.pet.species);
    breedProvider = StateProvider<String>((ref) => widget.pet.breed);
    genderProvider = StateProvider<String>((ref) => widget.pet.gender);
    sizeProvider = StateProvider<String>((ref) => widget.pet.size);
    weightProvider = StateProvider<String>((ref) => widget.pet.weight);
    birthDateProvider = StateProvider<DateTime>((ref) => widget.pet.birthDate);
    adoptionDateProvider =
        StateProvider<DateTime>((ref) => widget.pet.adoptionDate);
  }

  int findIndexByKeyValue(
      List<Map<String, String>> list, String key, dynamic value) {
    for (int i = 0; i < list.length; i++) {
      if (list[i][key] == value) {
        return i;
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    Pet pet = widget.pet;

    Future<void> pickImage(ImageSource source) async {
      try {
        XFile? tempImage =
            await ImagePicker().pickImage(source: source, imageQuality: 100);
        ref.read(imageProvider.notifier).state = tempImage;
      } catch (e) {
        print('Pick image error: $e');
      }
    }

    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const BasicAppBar(title: 'Edit Pet Profile'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: proportionateHeight(12)),
                          padding: EdgeInsets.all(proportionateHeight(16.5)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: AppColors.grey150)),
                          child: Container(
                            padding: EdgeInsets.all(proportionateHeight(16.5)),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: AppColors.grey150)),
                            child: CircleAvatar(
                              radius: proportionateWidth(50),
                              backgroundImage: ref.watch(imageProvider) == null
                                  ? NetworkImage(pet.photoURL)
                                  : FileImage(
                                          File(ref.watch(imageProvider)!.path))
                                      as ImageProvider<Object>,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: proportionateHeight(25),
                          child: GestureDetector(
                            onTap: () => pickImage(ImageSource.gallery),
                            child: Image.asset(
                              'assets/icons/change-pet-avatar.png',
                              width: proportionateWidth(40),
                              height: proportionateHeight(40),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    autovalidateMode: AutovalidateMode.always,
                    onChanged: () =>
                        Form.maybeOf(primaryFocus!.context!)?.save(),
                    child: CupertinoFormSection.insetGrouped(
                      backgroundColor: AppColors.lightBackground,
                      decoration:
                          BoxDecoration(color: AppColors.lightBackground),
                      margin: EdgeInsets.zero,
                      children: [
                        _TextField(
                          title: 'Name',
                          controller: nameTextController,
                        ),
                        _ListTile(
                          title: 'Species',
                          value: ref.watch(speciesProvider),
                          initialIndex: speciesList.indexOf(pet.species),
                          onSelectedItemChanged: (int selectedIndex) => ref
                              .read(speciesProvider.notifier)
                              .state = speciesList[selectedIndex],
                          list: speciesList,
                        ),
                        _ListTile(
                          title: 'Breed',
                          value: ref.watch(breedProvider),
                          initialIndex:
                              findIndexByKeyValue(dogBreeds, 'name', pet.breed),
                          onSelectedItemChanged: (int selectedIndex) => ref
                              .read(breedProvider.notifier)
                              .state = dogBreeds[selectedIndex]['name']!,
                          list: dogBreeds,
                          isListOfMap: true,
                        ),
                        _TextField(
                          title: 'Signs',
                          controller: signsTextController,
                        ),
                        _ListTile(
                          title: 'Gender',
                          value: ref.watch(genderProvider),
                          initialIndex: genderList.indexOf(pet.gender),
                          onSelectedItemChanged: (int selectedIndex) => ref
                              .read(genderProvider.notifier)
                              .state = genderList[selectedIndex],
                          list: genderList,
                        ),
                        _ListTile(
                          title: 'Size',
                          value: ref.watch(sizeProvider),
                          initialIndex: sizeList.indexOf(pet.size),
                          onSelectedItemChanged: (int selectedIndex) => ref
                              .read(sizeProvider.notifier)
                              .state = sizeList[selectedIndex],
                          list: sizeList,
                        ),
                        _ListTile(
                          title: 'Weight',
                          value: ref.watch(weightProvider),
                          initialIndex: double.parse(pet.weight).toInt(),
                          onSelectedItemChanged: (int selectedIndex) => ref
                              .read(weightProvider.notifier)
                              .state = weightList[selectedIndex],
                          list: weightList,
                        ),
                        _DateField(
                          title: 'Birthday',
                          value: ref.watch(birthDateProvider).format(),
                          onPressed: () => showDialog(
                              CupertinoDatePicker(
                                initialDateTime: ref.watch(birthDateProvider),
                                mode: CupertinoDatePickerMode.date,
                                onDateTimeChanged: (DateTime newDate) => ref
                                    .read(birthDateProvider.notifier)
                                    .state = newDate,
                              ),
                              context),
                        ),
                        _DateField(
                          title: 'Adoption date',
                          value: ref.watch(adoptionDateProvider).format(),
                          onPressed: () => showDialog(
                              CupertinoDatePicker(
                                initialDateTime:
                                    ref.watch(adoptionDateProvider),
                                mode: CupertinoDatePickerMode.date,
                                onDateTimeChanged: (DateTime newDate) => ref
                                    .read(adoptionDateProvider.notifier)
                                    .state = newDate,
                              ),
                              context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
            child: PrimaryButton(
              text: 'Save',
              press: () => ref
                  .read(petRepositoryProvider)
                  .updatePet(
                      pet.copyWith(
                        name: nameTextController.text,
                        species: ref.read(speciesProvider),
                        breed: ref.read(breedProvider),
                        signs: signsTextController.text,
                        gender: ref.read(genderProvider),
                        size: ref.read(sizeProvider),
                        weight:
                            double.tryParse(ref.read(weightProvider)) == null
                                ? '${ref.read(weightProvider)}.0'
                                : ref.read(weightProvider),
                        birthDate: ref.read(birthDateProvider),
                        adoptionDate: ref.read(adoptionDateProvider),
                      ),
                      ref.watch(imageProvider)?.path)
                  .then((_) => context.pop()),
              enable: true,
              background: AppColors.blue500,
            ),
          ),
        ],
      )),
    );
  }
}

class _ListTile extends ConsumerWidget {
  final String title;
  final String value;
  final int initialIndex;
  final void Function(int)? onSelectedItemChanged;
  final List list;
  final bool isListOfMap;

  const _ListTile({
    Key? key,
    required this.title,
    required this.value,
    required this.initialIndex,
    this.onSelectedItemChanged,
    required this.list,
    this.isListOfMap = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoListTile(
      title: Text(
        title,
        style: AppTextStyles.bodyRegular(15, AppColors.grey700),
      ),
      additionalInfo: Text(
        value,
        style: AppTextStyles.bodySemiBold(15, AppColors.grey800),
      ),
      trailing: const CupertinoListTileChevron(),
      padding: EdgeInsets.symmetric(vertical: proportionateHeight(8)),
      onTap: () => showDialog(
          CupertinoPicker(
            itemExtent: 40,
            scrollController: FixedExtentScrollController(
              initialItem: initialIndex,
            ),
            onSelectedItemChanged: onSelectedItemChanged,
            children: List<Widget>.generate(
              list.length,
              (int index) => Center(
                  child:
                      Text(isListOfMap ? list[index]['name']! : list[index])),
            ),
          ),
          context),
    );
  }
}

class _TextField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final int maxLines;

  const _TextField({
    Key? key,
    required this.title,
    required this.controller,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTextFormFieldRow(
      autocorrect: false,
      textCapitalization: TextCapitalization.sentences,
      controller: controller,
      maxLines: maxLines,
      prefix: Text(
        title,
        style: AppTextStyles.bodyRegular(15, AppColors.grey700),
      ),
      style: AppTextStyles.bodySemiBold(15, AppColors.grey800),
      padding: EdgeInsets.symmetric(vertical: proportionateHeight(5)),
      textAlign: TextAlign.end,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Required information';
        }
        return null;
      },
    );
  }
}

class _DateField extends ConsumerWidget {
  final String title;
  final String value;
  final VoidCallback onPressed;

  const _DateField({
    Key? key,
    required this.title,
    required this.value,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: proportionateHeight(2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyRegular(15, AppColors.grey700),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onPressed,
            child: Text(
              value,
              style: AppTextStyles.bodySemiBold(15, AppColors.grey800),
            ),
          ),
        ],
      ),
    );
  }
}
