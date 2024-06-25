import 'package:const_date_time/const_date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/application/pet_service.dart';
import 'package:petcare/src/layers/data/pet_repository.dart';
import 'package:petcare/src/layers/presentation/screens/add_pet/components/circle_avatar_with_effect.dart';
import 'package:petcare/src/utils/color.dart';
import 'package:petcare/src/utils/datetime.dart';
import '../../common_widgets/bottom_button_area.dart';
import '../../common_widgets/primary_button.dart';
import '../../common_widgets/appbar_with_step.dart';
import 'components/bottom_sheet.dart';

class APPImportantDatesScreen extends ConsumerWidget {
  const APPImportantDatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppBarWithStep(
              title: 'Add Pet Profile',
              stepName: 'Important Dates',
              step: 8,
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
                    CircleAvatarWithEffect(
                        photoURL: ref.read(newPetProvider).photoURL),
                    SizedBox(height: proportionateHeight(24)),
                    Text(
                      "Time to celebrate",
                      style: AppTextStyles.bodyMedium(14, AppColors.grey800),
                    ),
                    SizedBox(height: proportionateHeight(24)),
                    CustomDateWidget(dateType: 'birth'),
                    SizedBox(height: proportionateHeight(24)),
                    CustomDateWidget(dateType: 'adoption'),
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
                          .read(petRepositoryProvider)
                          .addPet(ref.read(newPetProvider))
                          .then((_) => ref.invalidate(newPetProvider))
                          .whenComplete(() => Navigator.of(context)
                              .popUntil((route) => route.isFirst));
                    },
                    enable: ref.watch(newPetProvider
                                .select((newPet) => newPet.birthDate)) !=
                            const ConstDateTime.utc(1000, 1, 1) &&
                        ref.watch(newPetProvider
                                .select((newPet) => newPet.adoptionDate)) !=
                            const ConstDateTime.utc(1000, 1, 1),
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

// ignore: must_be_immutable
class CustomDateWidget extends ConsumerWidget {
  CustomDateWidget({super.key, required this.dateType});
  String dateType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime date = ref.watch(newPetProvider.select((newPet) =>
        dateType == 'birth' ? newPet.birthDate : newPet.adoptionDate));
    return date == const ConstDateTime.utc(1000, 1, 1)
        ? Container(
            width: double.infinity,
            height: proportionateHeight(54),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.blue500),
                borderRadius: BorderRadius.circular(14)),
            child: TextButton(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) =>
                    BottomSheetContent(tabIndex: dateType == 'birth' ? 0 : 1),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                isScrollControlled: true,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(dateType == 'birth'
                      ? 'assets/icons/cake-blue.svg'
                      : 'assets/icons/home-blue.svg'),
                  SizedBox(width: proportionateWidth(8)),
                  Text(
                      dateType == 'birth'
                          ? 'Add birth date'
                          : 'Add adoption date',
                      style: AppTextStyles.bodyMedium(14, AppColors.blue500)),
                ],
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: proportionateWidth(16)),
            width: double.infinity,
            height: proportionateHeight(74),
            decoration: BoxDecoration(
              color: AppColors.grey0,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: HexColor('0C1A4B').withOpacity(0.08),
                  blurRadius: 5,
                ),
                BoxShadow(
                  color: HexColor('323247').withOpacity(0.04),
                  offset: const Offset(0, 4),
                  blurRadius: 20,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: TextButton(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) =>
                    BottomSheetContent(tabIndex: dateType == 'birth' ? 0 : 1),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                isScrollControlled: true,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(proportionateHeight(11)),
                        decoration: BoxDecoration(
                          color: HexColor('D1E6FF').withOpacity(0.5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                        ),
                        child: SvgPicture.asset(
                          dateType == 'birth'
                              ? 'assets/icons/cake-blue.svg'
                              : 'assets/icons/home-blue.svg',
                          width: proportionateWidth(20),
                          height: proportionateHeight(20),
                        ),
                      ),
                      SizedBox(width: proportionateWidth(10)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dateType == 'birth' ? 'Birthday' : 'Adoption day',
                            style: AppTextStyles.bodyRegular(
                                14, AppColors.grey600),
                          ),
                          SizedBox(height: proportionateHeight(2)),
                          Text(date.format(),
                            style: AppTextStyles.bodySemiBold(
                                14, AppColors.grey800),
                          )
                        ],
                      ),
                    ],
                  ),
                  dateType == 'birth'
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            VerticalDivider(
                              thickness: 1,
                              indent: 16,
                              endIndent: 16,
                              color: AppColors.grey150,
                            ),
                            SizedBox(width: proportionateWidth(16)),
                            Text(
                              date.toAge().toString(),
                              style: AppTextStyles.bodySemiBold(
                                  20, AppColors.grey800),
                            ),
                            SizedBox(width: proportionateWidth(4)),
                            Text(
                              'y.o',
                              style: AppTextStyles.bodyRegular(
                                  12, AppColors.grey600),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          );
  }
}
