import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/application/pet_service.dart';
import 'package:petcare/src/layers/data/insurance_repository.dart';
import 'package:petcare/src/layers/data/order_repository.dart';
import 'package:petcare/src/layers/presentation/common_widgets/secondary_button.dart';
import 'package:petcare/src/layers/domain/insurance_pack.dart';
import 'package:petcare/src/utils/datetime.dart';

import 'components/insurance_bottom_sheet.dart';

class InsuranceTab extends ConsumerWidget {
  const InsuranceTab({Key? key}) : super(key: key);

  String getPackIconPath(String packName) {
    if (packName == 'Basic Pack') {
      return 'assets/icons/umbrella-blue.svg';
    } else if (packName == 'Comfy Pack') {
      return 'assets/icons/shield-blue.svg';
    } else if (packName == 'King Pack') {
      return 'assets/icons/crown-blue.svg';
    }

    return '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget noValidInsuranceWidget() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: proportionateHeight(220),
                    child: Image.asset(
                      'assets/images/empty_insurance_background.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: proportionateHeight(24)),
                  Text(
                    "No insurance added",
                    style: AppTextStyles.titleBold(26, AppColors.grey800),
                  ),
                  SizedBox(height: proportionateHeight(10)),
                  Text(
                    "Our pet insurance plans can help reimburse vet bills related to injuries and illnesses, helping provide a financial safety net for unplanned circumstances.",
                    style: AppTextStyles.bodyMedium(16, AppColors.grey600),
                    textAlign: TextAlign.center,
                    maxLines: 5,
                  ),
                  SizedBox(height: proportionateHeight(36)),
                ],
              ),
            ),

            // Section 3 - Bottom Buttons Area
            SecondaryButton(
              iconData: CupertinoIcons.add,
              text: 'Add insurance',
              press: () => showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) => const InsuranceBottomSheet(),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                isScrollControlled: true,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: ref
              .read(orderRepositoryProvider)
              .fetchValidInsurance(ref.watch(selectedPetIdProvider)),
          builder: (context, validInsuranceSnapshot) {
            if (validInsuranceSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (validInsuranceSnapshot.hasError) {
              return Center(
                  child: Text('Error: ${validInsuranceSnapshot.error}'));
            } else {
              return validInsuranceSnapshot.data == null
                  ? noValidInsuranceWidget()
                  : StreamBuilder<InsurancePack>(
                      stream: ref
                          .read(insuranceRepositoryProvider)
                          .watch(validInsuranceSnapshot.data!.items[0]),
                      builder: (context, packSnapshot) {
                        if (packSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CupertinoActivityIndicator());
                        } else if (packSnapshot.hasError) {
                          return Center(
                              child: Text('Error: ${packSnapshot.error}'));
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          AppColors.blue500.withOpacity(0.07),
                                      spreadRadius: 27,
                                    ),
                                    BoxShadow(
                                      color:
                                          AppColors.blue500.withOpacity(0.05),
                                      spreadRadius: 57,
                                    ),
                                    BoxShadow(
                                      color:
                                          AppColors.blue500.withOpacity(0.07),
                                      spreadRadius: 87,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    getPackIconPath(packSnapshot.data!.name),
                                    height: proportionateHeight(150),
                                    width: proportionateWidth(150),
                                  ),
                                ),
                              ),
                              SizedBox(height: proportionateHeight(120)),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: proportionateWidth(24)),
                                child: Text(
                                  validInsuranceSnapshot.data!.paid
                                      ? "${packSnapshot.data!.name} Activated"
                                      : "Take your pet to the selected store to review the ${packSnapshot.data!.name}.",
                                  style: AppTextStyles.titleBold(
                                      26, AppColors.blue500),
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: proportionateHeight(10)),
                              if (validInsuranceSnapshot.data!.paid)
                                Text(
                                  "Valid until ${validInsuranceSnapshot.data!.dateCompleted.format()}.",
                                  style: AppTextStyles.bodyMedium(
                                      16, AppColors.grey600),
                                  textAlign: TextAlign.center,
                                  maxLines: 5,
                                ),
                            ],
                          );
                        }
                      },
                    );
            }
          },
        ),
      ),
    );
  }
}
