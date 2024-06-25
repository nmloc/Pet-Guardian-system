import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/application/pet_service.dart';
import 'package:petcare/src/layers/domain/pet.dart';
import 'package:petcare/src/routing/app_router.dart';
import 'package:petcare/src/utils/color.dart';

class ActivePetProfiles extends ConsumerWidget {
  final List<Pet> petList;

  const ActivePetProfiles(this.petList, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: proportionateHeight(20)),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
            height: proportionateHeight(28),
            child: Row(
              children: [
                Text(
                  'Active pet profiles',
                  style: AppTextStyles.bodySemiBold(16, AppColors.grey800),
                ),
                SizedBox(width: proportionateWidth(6)),
                Container(
                  alignment: Alignment.center,
                  width: proportionateWidth(25),
                  decoration: BoxDecoration(
                    color: AppColors.grey150,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    petList.length.toString(),
                    style: AppTextStyles.bodySemiBold(14, AppColors.grey700),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: proportionateHeight(16)),
            child: CarouselSlider(
              options: CarouselOptions(
                height: proportionateHeight(155),
                initialPage: petList.indexWhere(
                    (pet) => pet.id == ref.watch(selectedPetIdProvider)),
                viewportFraction: 0.88,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) => ref
                    .read(selectedPetIdProvider.notifier)
                    .state = (petList[index].id),
              ),
              items: petList
                  .map((pet) => _ActivePetProfileCard(pet: pet))
                  .toList(),
            ),
          ),
          Wrap(
            spacing: proportionateWidth(4),
            alignment: WrapAlignment.center,
            children: petList
                .map((pet) => pet.id == ref.watch(selectedPetIdProvider)
                    ? Container(
                        height: proportionateHeight(6),
                        width: proportionateWidth(22),
                        decoration: BoxDecoration(
                          color: AppColors.yellow500,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      )
                    : Container(
                        height: proportionateHeight(6),
                        width: proportionateWidth(6),
                        decoration: BoxDecoration(
                          color: AppColors.grey200,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ))
                .toList(),
          )
        ],
      ),
    );
  }
}

class _ActivePetProfileCard extends ConsumerWidget {
  final Pet pet;

  const _ActivePetProfileCard({
    super.key,
    required this.pet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedPetIdProvider.notifier).state = (pet.id);
        context.goNamed(AppRoute.petProfile.name);
      },
      child: Container(
        width: proportionateWidth(327),
        padding: EdgeInsets.symmetric(
          vertical: proportionateHeight(15),
          horizontal: proportionateWidth(20),
        ),
        margin: const EdgeInsets.only(right: 25, bottom: 25),
        decoration: BoxDecoration(
          color: AppColors.blue500,
          border: Border.all(color: AppColors.grey100),
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          boxShadow: [
            BoxShadow(
              color: HexColor('CCE1F7'),
              spreadRadius: 1,
              offset: const Offset(12.5, 12.5),
            ),
            BoxShadow(
              color: HexColor('CCE1F7').withOpacity(0.3),
              spreadRadius: 1,
              offset: const Offset(25, 25),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pet.name,
                  style: AppTextStyles.bodySemiBold(20, AppColors.grey0),
                ),
                SizedBox(height: proportionateHeight(5)),
                Text(
                  '${pet.species} | ${pet.breed}',
                  style: AppTextStyles.bodyRegular(14, AppColors.grey150),
                )
              ],
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey0.withOpacity(0.08),
                    spreadRadius: 15,
                  ),
                  BoxShadow(
                    color: HexColor('CCE1F7').withOpacity(0.04),
                    spreadRadius: 30,
                  ),
                  BoxShadow(
                    color: HexColor('CCE1F7').withOpacity(0.02),
                    spreadRadius: 45,
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(pet.photoURL),
                radius: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
