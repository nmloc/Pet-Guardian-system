import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare/src/layers/presentation/common_widgets/card_container.dart';
import 'package:petcare/src/layers/presentation/common_widgets/custom_expansion_tile.dart';
import 'package:petcare/src/layers/presentation/common_widgets/primary_button.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/data/vaccine_repository.dart';
import 'package:petcare/src/layers/domain/vaccine.dart';
import 'package:petcare/src/routing/app_router.dart';
import 'package:petcare/src/utils/int.dart';

class VaccineDetailScreen extends ConsumerWidget {
  final String vaccineId;
  const VaccineDetailScreen({required this.vaccineId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: StreamBuilder<Vaccine>(
        stream: ref.read(vaccineRepositoryProvider).watch(vaccineId),
        builder: (context, vaccineSnapshot) {
          if (vaccineSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (vaccineSnapshot.hasError) {
            return Center(child: Text('Error: ${vaccineSnapshot.error}'));
          } else {
            Vaccine vaccine = vaccineSnapshot.data!;
            return NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: proportionateHeight(330),
                    collapsedHeight: proportionateHeight(80),
                    flexibleSpace: SizedBox(
                      height: proportionateHeight(350),
                      child: Image.network(
                        vaccine.photoURL,
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
                                    vaccine.name,
                                    style: AppTextStyles.bodySemiBold(
                                        20, AppColors.grey800),
                                  ),
                                ),
                                SizedBox(height: proportionateHeight(2)),
                                SizedBox(
                                  width: proportionateWidth(230),
                                  child: Text(
                                    vaccine.manufacturer,
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
                                          AppColors.blue700.withOpacity(0.04),
                                      spreadRadius: 23,
                                    ),
                                    BoxShadow(
                                      color:
                                          AppColors.blue500.withOpacity(0.07),
                                      spreadRadius: 38,
                                    ),
                                    BoxShadow(
                                      color:
                                          AppColors.blue500.withOpacity(0.07),
                                      spreadRadius: 48,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  FontAwesomeIcons.pills,
                                  color: AppColors.blue500,
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
                    title: 'Indications',
                    children: [
                      _Item(
                        value:
                            'Effective for the vaccination of healthy ${vaccine.species.length > 1 ? 'dogs and cats.' : vaccine.species[0] == 'Feline' ? 'cats.' : 'dogs.'}',
                      ),
                    ],
                  ),
                  const _Divider(),
                  CustomExpansionTile(
                    title: 'Efficacy & Comparisons',
                    children: [
                      _Item(
                        value:
                            "Duration of immunity studies demonstrated that a 1 mL dose met federal guidelines for protection against virulent challenge administered ${vaccine.validMonth} months after vaccination.",
                      ),
                    ],
                  ),
                  const _Divider(),
                  CustomExpansionTile(
                    title: 'Administration & Dosage',
                    children: [
                      _Item(
                          value:
                              "Revaccinate dogs and cats every ${vaccine.validMonth} months with ${vaccine.primaryDoses} ${vaccine.primaryDoses == 1 ? 'dose' : 'doses'}"),
                      if (vaccine.repeatDoseWeek > 0)
                        _Item(
                            value:
                                "Repeat dose should be administered ${vaccine.repeatDoseWeek} weeks later")
                    ],
                  ),
                  const _Divider(),
                  CustomExpansionTile(
                    title: 'Price',
                    children: [
                      _PriceWidget(price: vaccine.price),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: proportionateHeight(24)),
                    child: PrimaryButton(
                      text: 'Book a date',
                      press: () => context.goNamed(
                        AppRoute.booking.name,
                        pathParameters: {"category": "Vaccine"},
                        queryParameters: {'itemId': vaccineId},
                      ),
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

class _Item extends StatelessWidget {
  final String value;

  const _Item({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity:
          const VisualDensity(vertical: VisualDensity.minimumDensity),
      title: Text(
        value,
        style: AppTextStyles.bodyMedium(14, AppColors.grey800),
        maxLines: 5,
      ),
    );
  }
}

class _PriceWidget extends ConsumerWidget {
  final int price;

  const _PriceWidget({
    super.key,
    required this.price,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity:
          const VisualDensity(vertical: VisualDensity.minimumDensity),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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
