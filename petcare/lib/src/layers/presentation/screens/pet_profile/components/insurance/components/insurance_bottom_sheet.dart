import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare/src/layers/presentation/common_widgets/appbar_with_step.dart';
import 'package:petcare/src/layers/presentation/common_widgets/primary_button.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/application/pet_service.dart';
import 'package:petcare/src/layers/data/insurance_repository.dart';
import 'package:petcare/src/layers/data/pet_repository.dart';
import 'package:petcare/src/layers/domain/insurance_pack.dart';
import 'package:petcare/src/layers/presentation/screens/pet_profile/components/insurance/components/pack_card.dart';
import 'package:petcare/src/routing/app_router.dart';
import 'package:petcare/src/utils/int.dart';

class InsuranceBottomSheet extends ConsumerStatefulWidget {
  const InsuranceBottomSheet({super.key});

  @override
  _InsuranceBottomSheetState createState() => _InsuranceBottomSheetState();
}

class _InsuranceBottomSheetState extends ConsumerState<InsuranceBottomSheet> {
  final stepProvider = StateProvider.autoDispose<int>((ref) => 1);
  final selectedIndexProvider = StateProvider.autoDispose<int>((ref) => 1);
  late List<Widget> contents;
  @override
  Widget build(BuildContext context) {
    final stepController = ref.watch(stepProvider);
    String stepName() {
      if (stepController == 1) {
        return 'Packages';
      } else if (stepController == 2) {
        return 'Package Details';
      } else {
        return 'How it works';
      }
    }

    return SafeArea(
      child: Container(
        color: AppColors.grey0,
        height: proportionateHeight(500),
        child: FutureBuilder(
          future: ref
              .read(petRepositoryProvider)
              .fetchPet(ref.read(selectedPetIdProvider)),
          builder: (context, selectedPetSnapshot) {
            if (selectedPetSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (selectedPetSnapshot.hasError) {
              return Center(child: Text('Error: ${selectedPetSnapshot.error}'));
            } else {
              return StreamBuilder(
                stream: ref
                    .watch(insuranceRepositoryProvider)
                    .watchInsurances(selectedPetSnapshot.data!.species),
                builder: (context, insuranceSnapshot) {
                  if (insuranceSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CupertinoActivityIndicator());
                  } else if (insuranceSnapshot.hasError) {
                    return Center(
                        child: Text('Error: ${insuranceSnapshot.error}'));
                  } else {
                    List<InsurancePack> packList = insuranceSnapshot.data!;
                    contents = [
                      packages(packList),
                      packageDetails(packList[ref.read(selectedIndexProvider)]),
                      howItWorks()
                    ];
                    return Column(
                      children: <Widget>[
                        SizedBox(height: proportionateHeight(16)),
                        AppBarWithStep(
                          title: 'Add Insurance',
                          stepName: stepName(),
                          step: stepController,
                          totalStep: 3,
                          press: () => stepController == 1
                              ? context.pop()
                              : ref.read(stepProvider.notifier).state--,
                        ),
                        SizedBox(height: proportionateHeight(32)),
                        if (stepController == 2)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: proportionateWidth(24)),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                packList[ref.read(selectedIndexProvider)].name,
                                style: AppTextStyles.bodySemiBold(
                                    16, AppColors.grey800),
                              ),
                            ),
                          ),
                        SizedBox(height: proportionateHeight(12)),
                        Expanded(
                          child: contents[stepController - 1],
                        ),
                        // Section 4 - Done Button
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: proportionateWidth(24)),
                          child: PrimaryButton(
                            text: stepController != 3 ? 'Next' : 'Confirm',
                            press: () {
                              if (stepController != 3) {
                                ref.read(stepProvider.notifier).state++;
                              } else {
                                context.pop();
                                context.pushNamed(
                                  AppRoute.booking.name,
                                  pathParameters: {"category": "Insurance"},
                                  queryParameters: {
                                    "itemId": packList[
                                            ref.watch(selectedIndexProvider)]
                                        .id
                                  },
                                );
                              }
                            },
                            enable: true,
                          ),
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

  Consumer packages(List<InsurancePack> packList) {
    return Consumer(builder: (context, ref, child) {
      final selectedIndex = ref.watch(selectedIndexProvider);
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: packList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              GestureDetector(
                child: PackCard(
                  pack: packList[index],
                  isSelected: selectedIndex == index,
                ),
                onTap: () =>
                    ref.read(selectedIndexProvider.notifier).state = index,
              ),
              if (index < packList.length - 1)
                SizedBox(height: proportionateHeight(16)),
            ],
          );
        },
      );
    });
  }

  Widget packageDetails(InsurancePack pack) {
    String title(int index) => pack.details.keys.toList()[index];
    int price(int index) => pack.details.values.toList()[index];
    int detailsNum() => pack.details.length;
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: pack.details.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            SizedBox(
              height: proportionateHeight(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title(index),
                      style: AppTextStyles.bodyRegular(14, AppColors.grey700)),
                  Text(price(index).toVND(),
                      style: AppTextStyles.bodySemiBold(14, AppColors.grey800)),
                ],
              ),
            ),
            if (index < detailsNum() - 1)
              SizedBox(height: proportionateHeight(6)),
            if (index < detailsNum() - 1)
              Divider(color: AppColors.grey150, thickness: 1),
            if (index < detailsNum() - 1)
              SizedBox(height: proportionateHeight(6)),
          ],
        );
      },
    );
  }

  Widget howItWorks() {
    Widget instructionCard(String text1, String text2) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.check,
              color: AppColors.lightGreen500,
              size: 18,
            ),
            SizedBox(width: proportionateWidth(4)),
            SizedBox(
              width: proportionateWidth(305),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text1,
                    style: AppTextStyles.bodySemiBold(14, AppColors.grey800),
                    maxLines: 2,
                  ),
                  SizedBox(height: proportionateHeight(4)),
                  Text(
                    text2,
                    style: AppTextStyles.bodyRegular(14, AppColors.grey700),
                    maxLines: 5,
                  ),
                ],
              ),
            )
          ],
        );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
      child: Column(
        children: [
          instructionCard(
            "Take your pet to the vet",
            "Visit any licensed vet, emergency clinic or specialist in the U.S. There's no network of providers to worry about.",
          ),
          SizedBox(height: proportionateHeight(16)),
          instructionCard(
            "Send us your claim",
            "Pay your pet's vet bill, and send us your claim along with vet records and invoice from the visit.",
          ),
          SizedBox(height: proportionateHeight(16)),
          instructionCard(
            "Get money back quickly",
            "We will follow up with your vet for any missing info. Claims are typically processed in less than 2 weeks.",
          ),
        ],
      ),
    );
  }
}
