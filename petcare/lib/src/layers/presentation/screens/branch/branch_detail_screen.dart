// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare/src/layers/presentation/common_widgets/card_container.dart';
import 'package:petcare/src/layers/presentation/common_widgets/custom_expansion_tile.dart';
import 'package:petcare/src/layers/presentation/common_widgets/primary_button.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/data/branch_repository.dart';
import 'package:petcare/src/layers/data/grooming_repository.dart';
import 'package:petcare/src/layers/domain/branch.dart';
import 'package:petcare/src/layers/domain/grooming_service.dart';
import 'package:petcare/src/routing/app_router.dart';
import 'package:petcare/src/utils/int.dart';

class BranchDetailScreen extends ConsumerWidget {
  final String branchId;
  const BranchDetailScreen(this.branchId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: StreamBuilder<Branch>(
        stream: ref.read(branchRepositoryProvider).watchBranch(branchId),
        builder: (context, branchSnapshot) {
          if (branchSnapshot.connectionState == ConnectionState.waiting) {
            return const CupertinoActivityIndicator();
          } else if (branchSnapshot.hasError) {
            return Center(child: Text('Error: ${branchSnapshot.error}'));
          } else {
            Branch branch = branchSnapshot.data!;
            return NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: proportionateHeight(300),
                    collapsedHeight: proportionateHeight(80),
                    flexibleSpace: SizedBox(
                      height: proportionateHeight(317),
                      child: Image.asset(
                        'assets/images/grooming-background.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(80),
                      child: CardContainer(
                        clipBehavior: Clip.hardEdge,
                        height: proportionateHeight(80),
                        margin: EdgeInsets.symmetric(
                            horizontal: proportionateWidth(24)),
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: proportionateWidth(230),
                                  child: Text(
                                    branch.name,
                                    style: AppTextStyles.bodySemiBold(
                                        20, AppColors.grey800),
                                  ),
                                ),
                                SizedBox(height: proportionateHeight(2)),
                                SizedBox(
                                  width: proportionateWidth(230),
                                  child: Text(
                                    branch.address(),
                                    style: AppTextStyles.bodyRegular(
                                        14, AppColors.grey600),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              right: proportionateWidth(0),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          AppColors.purple700.withOpacity(0.04),
                                      spreadRadius: 23,
                                    ),
                                    BoxShadow(
                                      color:
                                          AppColors.purple500.withOpacity(0.07),
                                      spreadRadius: 38,
                                    ),
                                    BoxShadow(
                                      color:
                                          AppColors.purple500.withOpacity(0.07),
                                      spreadRadius: 48,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  CupertinoIcons.scissors_alt,
                                  color: AppColors.purple500,
                                  size: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ];
              },
              body: ListView(
                padding:
                    EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
                children: [
                  CustomExpansionTile(
                    title: 'Contact',
                    children: [
                      _ContactItem(
                        title: 'Phone:',
                        value: branch.phoneNumber,
                        iconData: Icons.phone_in_talk_outlined,
                      ),
                      _ContactItem(
                        title: 'Email:',
                        value: branch.email,
                        iconData: CupertinoIcons.paperplane,
                      ),
                    ],
                  ),
                  const _Divider(),
                  CustomExpansionTile(
                    title: 'Location',
                    children: [
                      _LocationItem(
                        title: 'Street: ',
                        value: branch.street,
                      ),
                      _LocationItem(
                        title: 'Ward: ',
                        value: branch.ward,
                      ),
                      _LocationItem(
                        title: 'District: ',
                        value: branch.district,
                      ),
                      _LocationItem(
                        title: 'City: ',
                        value: branch.city,
                      ),
                    ],
                  ),
                  const _Divider(),
                  CustomExpansionTile(
                    title: 'Availability',
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(
                            vertical: VisualDensity.minimumDensity),
                        title: GridView.count(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 7,
                          crossAxisSpacing: 8,
                          shrinkWrap: true,
                          childAspectRatio: 40 / 32,
                          children: [
                            {'text': 'M', 'isAvailable': true},
                            {'text': 'T', 'isAvailable': true},
                            {'text': 'W', 'isAvailable': true},
                            {'text': 'T', 'isAvailable': true},
                            {'text': 'F', 'isAvailable': true},
                            {'text': 'S', 'isAvailable': true},
                            {'text': 'S', 'isAvailable': false},
                          ]
                              .map((item) => _AvailabilityItem(
                                  text: item['text'] as String,
                                  isAvailable: item['isAvailable'] as bool))
                              .toList(),
                        ),
                      ),
                      const _LocationItem(
                          title: 'Hours: ', value: '10:00 - 20:00')
                    ],
                  ),
                  const _Divider(),
                  CustomExpansionTile(
                    title: 'Services',
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(
                            vertical: VisualDensity.minimumDensity),
                        title: StreamBuilder<List<GroomingService>>(
                          stream: ref
                              .read(groomingRepositoryProvider)
                              .watchServices(),
                          builder: (context, groomingServiceSnapshot) {
                            if (groomingServiceSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CupertinoActivityIndicator();
                            } else if (groomingServiceSnapshot.hasError) {
                              return Center(
                                  child: Text(
                                      'Error: ${groomingServiceSnapshot.error}'));
                            } else {
                              List<GroomingService> groomingServiceList =
                                  groomingServiceSnapshot.data!;
                              return SizedBox(
                                height: proportionateHeight(200),
                                child: ListView.separated(
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 3,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: proportionateHeight(16)),
                                  itemBuilder: (context, index) =>
                                      _ServiceItemWidget(
                                    name: groomingServiceList[index].name,
                                    price: groomingServiceList[index].price,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: proportionateHeight(24)),
                    child: PrimaryButton(
                      text: 'Book a date',
                      press: () => context.goNamed(AppRoute.petProfile.name),
                      enable: true,
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: proportionateHeight(1),
      margin: EdgeInsets.only(
        top: proportionateHeight(10),
      ),
      color: AppColors.grey150,
    );
  }
}

class _ContactItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData iconData;

  const _ContactItem({
    Key? key,
    required this.title,
    required this.value,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyRegular(14, AppColors.grey700),
              ),
              SizedBox(height: proportionateHeight(4)),
              Text(
                value,
                style: AppTextStyles.bodyMedium(14, AppColors.grey800),
              )
            ],
          ),
          CardContainer(
            height: proportionateHeight(38),
            width: proportionateWidth(38),
            padding: EdgeInsets.zero,
            child: Icon(
              iconData,
              color: AppColors.blue500,
            ),
          )
        ],
      ),
    );
  }
}

class _LocationItem extends StatelessWidget {
  final String title;
  final String value;

  const _LocationItem({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity:
          const VisualDensity(vertical: VisualDensity.minimumDensity),
      title: Row(
        children: [
          Text(
            title,
            style: AppTextStyles.bodyRegular(14, AppColors.grey700),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium(14, AppColors.grey800),
          )
        ],
      ),
    );
  }
}

class _AvailabilityItem extends StatelessWidget {
  final String text;
  final bool isAvailable;

  const _AvailabilityItem({
    Key? key,
    required this.text,
    required this.isAvailable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: (isAvailable
              ? BoxDecoration(
                  color: AppColors.blue100.withOpacity(0.5),
                  border: Border.all(color: AppColors.blue100))
              : BoxDecoration(
                  color: AppColors.grey100,
                  border: Border.all(color: AppColors.grey150)))
          .copyWith(borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(
          text,
          style: isAvailable
              ? AppTextStyles.bodySemiBold(16, AppColors.blue500)
              : AppTextStyles.bodyMedium(16, AppColors.grey500),
        ),
      ),
    );
  }
}

class _ServiceItemWidget extends ConsumerWidget {
  final String name;
  final int price;

  const _ServiceItemWidget({
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CardContainer(
      height: proportionateHeight(56),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: AppTextStyles.bodySemiBold(14, AppColors.grey800),
            ),
          ),
          Text(
            price.formatPrice(),
            style: AppTextStyles.bodySemiBold(20, AppColors.grey900),
          ),
          SizedBox(width: proportionateWidth(10)),
          Text(
            'VND',
            style: AppTextStyles.bodyRegular(12, AppColors.grey900),
          ),
        ],
      ),
    );
  }
}
