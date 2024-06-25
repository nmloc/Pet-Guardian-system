import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/application/pet_service.dart';
import 'package:petcare/src/layers/data/pet_repository.dart';
import 'package:petcare/src/layers/domain/pet.dart';
import 'package:petcare/src/layers/presentation/common_widgets/primary_button.dart';
import 'package:petcare/src/routing/app_router.dart';
import 'package:petcare/src/utils/datetime.dart';

class AboutTab extends ConsumerWidget {
  const AboutTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget customInfoBar(String title, String value) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.bodyRegular(14, AppColors.grey700),
            ),
            Text(
              value,
              style: AppTextStyles.bodySemiBold(14, AppColors.grey800),
            ),
          ],
        );

    return StreamBuilder<Pet>(
        stream: ref
            .read(petRepositoryProvider)
            .watchPet(ref.watch(selectedPetIdProvider)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CupertinoActivityIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Pet pet = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                        horizontal: proportionateWidth(24)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: proportionateHeight(162),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.grey150,
                                      spreadRadius: 17,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(pet.photoURL),
                                  radius: 64,
                                ),
                              ),
                              SizedBox(width: proportionateWidth(37)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        pet.name,
                                        style: AppTextStyles.bodySemiBold(
                                            22, AppColors.grey800),
                                      ),
                                      SizedBox(width: proportionateWidth(12)),
                                      Container(
                                        height: proportionateHeight(38),
                                        width: proportionateWidth(38),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.blue500),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            CupertinoIcons.pencil_outline,
                                            size: 20,
                                            color: AppColors.blue500,
                                          ),
                                          onPressed: () => context.goNamed(
                                            AppRoute.editPetProfile.name,
                                            extra: pet,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: proportionateHeight(6)),
                                  Text(
                                    "${pet.species} | ${pet.breed}",
                                    style: AppTextStyles.bodyRegular(
                                        14, AppColors.grey600),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),

                        Text(
                          'Appearance and distinctive signs',
                          style:
                              AppTextStyles.bodySemiBold(16, AppColors.grey800),
                        ),
                        SizedBox(height: proportionateHeight(4)),
                        Text(
                          pet.signs,
                          style:
                              AppTextStyles.bodyRegular(14, AppColors.grey700),
                        ),
                        SizedBox(height: proportionateHeight(16)),
                        customInfoBar('Gender', pet.gender),
                        Divider(thickness: 1, color: AppColors.grey150),
                        customInfoBar('Size', pet.size),
                        Divider(thickness: 1, color: AppColors.grey150),
                        customInfoBar('Weight', pet.weight),

                        SizedBox(height: proportionateHeight(24)),

                        // Section 3 - Important Dates
                        Text(
                          'Important Dates',
                          style:
                              AppTextStyles.bodySemiBold(16, AppColors.grey800),
                        ),
                        SizedBox(height: proportionateHeight(16)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: proportionateHeight(46),
                                  width: proportionateWidth(46),
                                  padding: const EdgeInsets.all(13),
                                  decoration: BoxDecoration(
                                    color: AppColors.blue100.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: SvgPicture.asset(
                                      'assets/icons/cake-blue.svg'),
                                ),
                                SizedBox(width: proportionateWidth(10)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Birthday',
                                      style: AppTextStyles.bodyRegular(
                                          14, AppColors.grey600),
                                    ),
                                    SizedBox(height: proportionateHeight(2)),
                                    Text(
                                      pet.birthDate.format(pattern: 'd MMMM y'),
                                      style: AppTextStyles.bodySemiBold(
                                          14, AppColors.grey800),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Text(
                              '${pet.birthDate.toAge()} y.o',
                              style: AppTextStyles.bodySemiBold(
                                  16, AppColors.grey800),
                            )
                          ],
                        ),
                        SizedBox(height: proportionateHeight(12)),
                        Divider(thickness: 1, color: AppColors.grey150),
                        SizedBox(height: proportionateHeight(12)),
                        Row(
                          children: [
                            Container(
                              height: proportionateHeight(46),
                              width: proportionateWidth(46),
                              padding: const EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                color: AppColors.blue100.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: SvgPicture.asset(
                                  'assets/icons/home-blue.svg'),
                            ),
                            SizedBox(width: proportionateWidth(10)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Adoption date',
                                  style: AppTextStyles.bodyRegular(
                                      14, AppColors.grey600),
                                ),
                                SizedBox(height: proportionateHeight(2)),
                                Text(
                                  pet.adoptionDate.format(pattern: 'd MMMM y'),
                                  style: AppTextStyles.bodySemiBold(
                                      14, AppColors.grey800),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: proportionateHeight(24)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
                  child: PrimaryButton(
                    text: 'Delete Profile',
                    press: () => showCupertinoModalPopup(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: Text(
                          'Delete pet profile?',
                          style: AppTextStyles.bodyBold(17, AppColors.grey1000),
                        ),
                        content: Padding(
                          padding:
                              EdgeInsets.only(top: proportionateHeight(10)),
                          child: Text(
                            'This pet profile will be permanently deleted. All health, nutrition and activity histories using all or part of this pet profile will also be deleted.',
                            style: AppTextStyles.bodyRegular(
                                14, AppColors.grey800),
                            maxLines: 10,
                          ),
                        ),
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () async {
                              await ref
                                  .read(petRepositoryProvider)
                                  .deletePet(pet.id, pet.photoURL);
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            },
                            child: Text(
                              'Delete',
                              style:
                                  AppTextStyles.bodyBold(16, AppColors.red500),
                            ),
                          ),
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            onPressed: () => context.pop(),
                            child: Text(
                              'Cancel',
                              style: AppTextStyles.bodyRegular(
                                  16, AppColors.grey1000),
                            ),
                          )
                        ],
                      ),
                    ),
                    enable: true,
                    background: AppColors.red500,
                  ),
                ),
              ],
            );
          }
        });
  }
}
