import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:petcare_staff/src/constants/app_colors.dart';
import 'package:petcare_staff/src/constants/app_sizes.dart';
import 'package:petcare_staff/src/constants/app_text_styles.dart';
import 'package:petcare_staff/src/layers/data/pet_repository.dart';
import 'package:petcare_staff/src/layers/domain/pet.dart';
import 'package:petcare_staff/src/layers/presentation/common_widgets/appbar_with_pet.dart';
import 'package:petcare_staff/src/utils/age.dart';

class PetProfileScreen extends ConsumerStatefulWidget {
  final String petId;
  const PetProfileScreen({Key? key, required this.petId}) : super(key: key);

  @override
  _PetProfileScreenState createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends ConsumerState<PetProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ref.watch(petRepositoryProvider).watchPet(widget.petId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CupertinoActivityIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final Pet pet = snapshot.data;
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  // Section 1 - Custom Appbar
                  AppBarWithPet(name: pet.name, photoURL: pet.photoURL),
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
                                    Text(pet.name,
                                        style: AppTextStyles.bodySemiBold(
                                            22, AppColors.grey800)),
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
                            style: AppTextStyles.bodySemiBold(
                                16, AppColors.grey800),
                          ),
                          SizedBox(height: proportionateHeight(4)),
                          Text(
                            pet.signs,
                            style: AppTextStyles.bodyRegular(
                                14, AppColors.grey700),
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
                            style: AppTextStyles.bodySemiBold(
                                16, AppColors.grey800),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Birthday',
                                        style: AppTextStyles.bodyRegular(
                                            14, AppColors.grey600),
                                      ),
                                      SizedBox(height: proportionateHeight(2)),
                                      Text(
                                        DateFormat('d MMMM y')
                                            .format(pet.birthDate),
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
                                    DateFormat('d MMMM y')
                                        .format(pet.adoptionDate),
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
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

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
