import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare/src/layers/presentation/common_widgets/primary_button.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/data/branch_repository.dart';
import 'package:petcare/src/layers/data/grooming_repository.dart';
import 'package:petcare/src/layers/data/order_repository.dart';
import 'package:petcare/src/layers/data/pet_repository.dart';
import 'package:petcare/src/layers/data/staff_repository.dart';
import 'package:petcare/src/layers/data/vaccine_repository.dart';
import 'package:petcare/src/layers/domain/branch.dart';
import 'package:petcare/src/layers/domain/grooming_service.dart';
import 'package:petcare/src/layers/domain/order.dart';
import 'package:petcare/src/layers/domain/pet.dart';
import 'package:petcare/src/layers/domain/staff.dart';
import 'package:petcare/src/layers/domain/vaccine.dart';
import 'package:petcare/src/utils/datetime.dart';

class VaccineBottomSheet extends ConsumerWidget {
  final String vaccineOrderId;
  const VaccineBottomSheet(this.vaccineOrderId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget section(
        {required String title,
        required Map<dynamic, dynamic> items,
        bool useStream = false}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyMedium(14, AppColors.grey800),
          ),
          SizedBox(height: proportionateHeight(12)),
          Row(
            mainAxisAlignment: items.length > 2
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.start,
            children: items.entries
                .map(
                  (entry) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: entry.key != '' && entry.key is String
                            ? proportionateHeight(42)
                            : proportionateHeight(20),
                        width: 1,
                        color: AppColors.grey150,
                      ),
                      SizedBox(width: proportionateWidth(12)),
                      SizedBox(
                        width: (AppSizes.screenWidth -
                                proportionateWidth(48) -
                                proportionateWidth(13) * items.length) /
                            items.length,
                        child: useStream
                            ? StreamBuilder<GroomingService>(
                                stream: ref
                                    .read(groomingRepositoryProvider)
                                    .watch(entry.value),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CupertinoActivityIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else {
                                    return Text(
                                      snapshot.data!.name,
                                      style: AppTextStyles.bodySemiBold(
                                          14, AppColors.grey800),
                                    );
                                  }
                                },
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (entry.key != '')
                                    Text(
                                      entry.key,
                                      style: AppTextStyles.bodyRegular(
                                          14, AppColors.grey700),
                                    ),
                                  Text(
                                    entry.value,
                                    style: AppTextStyles.bodySemiBold(
                                        14, AppColors.grey800),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      );
    }

    return SafeArea(
      bottom: false,
      child: StreamBuilder(
        stream: ref.read(orderRepositoryProvider).watch(vaccineOrderId),
        builder: (context, vaccineOrderSnapshot) {
          if (vaccineOrderSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (vaccineOrderSnapshot.hasError) {
            return Center(child: Text('Error: ${vaccineOrderSnapshot.error}'));
          } else {
            OrderModel order = vaccineOrderSnapshot.data!;
            return Container(
              color: AppColors.grey0,
              height: order.dateCompleted.isDefault()
                  ? proportionateHeight(520)
                  : proportionateHeight(620),
              child: StreamBuilder(
                stream:
                    ref.read(vaccineRepositoryProvider).watch(order.items[0]),
                builder: (context, vaccineSnapshot) {
                  if (vaccineSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CupertinoActivityIndicator());
                  } else if (vaccineSnapshot.hasError) {
                    return Center(
                        child: Text('Error: ${vaccineSnapshot.error}'));
                  } else {
                    Vaccine vaccine = vaccineSnapshot.data!;
                    return Padding(
                      padding: EdgeInsets.all(proportionateHeight(24)),
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vaccine.name,
                                  style: AppTextStyles.bodySemiBold(
                                      16, AppColors.grey800),
                                ),
                                SizedBox(height: proportionateHeight(24)),
                                StreamBuilder<Pet>(
                                  stream: ref
                                      .read(petRepositoryProvider)
                                      .watchPet(order.petId),
                                  builder: (context, petSnapshot) {
                                    if (petSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CupertinoActivityIndicator());
                                    } else if (petSnapshot.hasError) {
                                      return Center(
                                          child: Text(
                                              'Error: ${petSnapshot.error}'));
                                    } else {
                                      return section(
                                        title: 'Pet',
                                        items: {
                                          'Name': petSnapshot.data!.name,
                                          'Species': petSnapshot.data!.species,
                                        },
                                      );
                                    }
                                  },
                                ),
                                SizedBox(height: proportionateHeight(24)),
                                StreamBuilder<Branch>(
                                  stream: ref
                                      .read(branchRepositoryProvider)
                                      .watchBranch(order.branchId),
                                  builder: (context, branchSnapshot) {
                                    if (branchSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CupertinoActivityIndicator());
                                    } else if (branchSnapshot.hasError) {
                                      return Center(
                                          child: Text(
                                              'Error: ${branchSnapshot.error}'));
                                    } else {
                                      return section(
                                        title: 'Branch',
                                        items: {
                                          '': branchSnapshot.data!.name,
                                        },
                                      );
                                    }
                                  },
                                ),
                                if (!order.dateCompleted.isDefault())
                                  SizedBox(height: proportionateHeight(24)),
                                if (!order.dateCompleted.isDefault())
                                  section(
                                    title: 'Validation',
                                    items: {
                                      'Vaccination date':
                                          order.dateCompleted.format(),
                                      'Valid until': order.dateCompleted
                                          .addMonths(vaccine.validMonth)
                                          .format(),
                                    },
                                  ),
                                SizedBox(height: proportionateHeight(24)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Veterinarian',
                                      style: AppTextStyles.bodyMedium(
                                          14, AppColors.grey800),
                                    ),
                                    SizedBox(height: proportionateHeight(12)),
                                    Container(
                                      height: proportionateHeight(80),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: proportionateWidth(16),
                                        vertical: proportionateHeight(13),
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.grey150),
                                          borderRadius:
                                              BorderRadius.circular(14)),
                                      child: StreamBuilder<Staff>(
                                        stream: ref
                                            .read(staffRepositoryProvider)
                                            .watch(order.staffId),
                                        builder: (context, staffSnapshot) {
                                          if (staffSnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CupertinoActivityIndicator());
                                          } else if (staffSnapshot.hasError) {
                                            return Center(
                                                child: Text(
                                                    'Error: ${staffSnapshot.error}'));
                                          } else {
                                            Staff staff = staffSnapshot.data!;
                                            return Row(
                                              children: [
                                                CircleAvatar(
                                                  foregroundImage: staff
                                                              .photoURL ==
                                                          ''
                                                      ? const AssetImage(
                                                              'assets/images/default_user_avatar.jpg')
                                                          as ImageProvider
                                                      : NetworkImage(
                                                          staff.photoURL),
                                                  radius:
                                                      proportionateHeight(27),
                                                ),
                                                SizedBox(
                                                    width:
                                                        proportionateWidth(10)),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      staff.displayName,
                                                      style: AppTextStyles
                                                          .bodySemiBold(
                                                              14,
                                                              AppColors
                                                                  .grey800),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            proportionateHeight(
                                                                2)),
                                                    Text(
                                                      'Veterinarian Specialist',
                                                      style: AppTextStyles
                                                          .bodyRegular(
                                                              14,
                                                              AppColors
                                                                  .grey600),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: proportionateHeight(24)),
                                section(
                                  title: 'Notes',
                                  items: {'': 'No bad reactions'},
                                ),
                                SizedBox(height: proportionateHeight(12)),
                              ],
                            ),
                          ),
                          PrimaryButton(
                            text: 'Done',
                            press: () => context.pop(),
                            enable: true,
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }
}
