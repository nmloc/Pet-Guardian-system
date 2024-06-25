import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/application/pet_service.dart';
import 'package:petcare/src/layers/data/pet_repository.dart';
import 'package:petcare/src/layers/domain/pet.dart';

// ignore: must_be_immutable
class AppBarWithPet extends ConsumerWidget {
  AppBarWithPet({
    Key? key,
    this.isAbleToChangePet = true,
    this.service,
    this.isPetProfile = true,
  }) : super(key: key);

  final bool isAbleToChangePet;
  String? service;
  final bool isPetProfile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(
          left: proportionateWidth(12), right: proportionateWidth(24)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              IconButton(
                alignment: Alignment.centerLeft,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.grey600,
                  size: 20,
                ),
                onPressed: () => context.pop(),
              ),
              Container(
                height: proportionateHeight(22),
                width: proportionateWidth(1),
                decoration: BoxDecoration(color: AppColors.grey200),
              ),
              SizedBox(width: proportionateWidth(8)),
              Expanded(
                child: service == null
                    ? Text('Pet Profile',
                        style: AppTextStyles.titleBold(18, AppColors.grey800))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isPetProfile)
                            Text(
                              'Pet Profile',
                              style: AppTextStyles.bodyRegular(
                                  14, AppColors.grey600),
                            ),
                          Text(
                            service!,
                            style:
                                AppTextStyles.titleBold(18, AppColors.grey800),
                          ),
                        ],
                      ),
              ),
              isAbleToChangePet
                  ? StreamBuilder<Pet>(
                      stream: ref
                          .read(petRepositoryProvider)
                          .watchPet(ref.watch(selectedPetIdProvider)),
                      builder: (context, petSnapshot) {
                        if (petSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CupertinoActivityIndicator();
                        } else if (petSnapshot.hasError) {
                          return Center(
                              child: Text('Error: ${petSnapshot.error}'));
                        } else {
                          return StreamBuilder<List<Pet>>(
                            stream: ref.read(petRepositoryProvider).watchPets(),
                            builder: (context, petsSnapshot) {
                              if (petsSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CupertinoActivityIndicator();
                              } else if (petsSnapshot.hasError) {
                                return Center(
                                    child:
                                        Text('Error: ${petsSnapshot.error}'));
                              } else {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                    value: petSnapshot.data!.id,
                                    onChanged: (newPetId) => ref
                                        .read(selectedPetIdProvider.notifier)
                                        .state = (newPetId!),
                                    iconStyleData: IconStyleData(
                                      icon: Icon(
                                        CupertinoIcons.chevron_down,
                                        color: AppColors.grey600,
                                        size: 14,
                                      ),
                                    ),
                                    buttonStyleData: ButtonStyleData(
                                      width: proportionateWidth(111),
                                      height: proportionateHeight(40),
                                      padding: EdgeInsets.symmetric(
                                        vertical: proportionateHeight(10),
                                        horizontal: proportionateWidth(14),
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.grey150,
                                        border:
                                            Border.all(color: AppColors.linear),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      decoration: BoxDecoration(
                                        color: AppColors.grey150,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      scrollbarTheme: ScrollbarThemeData(
                                        radius: const Radius.circular(40),
                                        thickness: MaterialStateProperty.all(6),
                                        thumbVisibility:
                                            MaterialStateProperty.all(true),
                                      ),
                                      elevation: 2,
                                    ),
                                    items: petsSnapshot.data!
                                        .map<DropdownMenuItem<String>>(
                                            (Pet pet) {
                                      return DropdownMenuItem(
                                        value: pet.id,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(pet.photoURL),
                                              radius: 10,
                                            ),
                                            SizedBox(
                                                width: proportionateWidth(5)),
                                            SizedBox(
                                              width: proportionateWidth(45),
                                              child: Text(
                                                pet.name,
                                                style:
                                                    AppTextStyles.bodySemiBold(
                                                        14, AppColors.grey800),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              }
                            },
                          );
                        }
                      },
                    )
                  : StreamBuilder<Pet>(
                      stream: ref
                          .read(petRepositoryProvider)
                          .watchPet(ref.read(selectedPetIdProvider)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CupertinoActivityIndicator();
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              vertical: proportionateHeight(10),
                              horizontal: proportionateWidth(14),
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.grey150,
                              border: Border.all(color: AppColors.linear),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(snapshot.data!.photoURL),
                                  radius: 10,
                                ),
                                SizedBox(width: proportionateWidth(4)),
                                Text(
                                  snapshot.data!.name,
                                  style: AppTextStyles.bodySemiBold(
                                      14, AppColors.grey800),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
            ],
          ),
          SizedBox(height: proportionateHeight(12)),

          // Custom fade out divider
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.transparent,
                  AppColors.radial,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
