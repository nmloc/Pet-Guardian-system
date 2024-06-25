import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petcare/src/layers/presentation/common_widgets/card_container.dart';
import 'package:petcare/src/layers/presentation/common_widgets/secondary_button.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/data/staff_repository.dart';
import 'package:petcare/src/layers/domain/order.dart';
import 'package:petcare/src/layers/domain/staff.dart';
import 'package:petcare/src/layers/presentation/screens/pet_profile/components/grooming/components/grooming_bottom_sheet.dart';
import 'package:petcare/src/utils/datetime.dart';

import 'grooming_tab_lazy_load.dart';

class GroomingTab extends ConsumerWidget {
  GroomingTab({super.key});

  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget emptyGroomingWidget() {
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
                      'assets/images/empty_grooming_background.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: proportionateHeight(24)),
                  Text(
                    "No grooming services used",
                    style: AppTextStyles.titleBold(26, AppColors.grey800),
                  ),
                  SizedBox(height: proportionateHeight(10)),
                  Text(
                    "Our pet grooming services offer professional care to keep your furry companions looking and feeling their best, ensuring they receive top-notch pampering and hygiene maintenance.",
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
              text: 'Book a date',
              press: () {},
            ),
          ],
        ),
      );
    }

    final lazyLoadAsync = ref.watch(groomingTabLazyLoadProvider);
    bool _hasMore = ref.watch(groomingTabLazyLoadProvider.notifier).hasMore;
    bool isInitialFetching =
        lazyLoadAsync.isLoading && (lazyLoadAsync.value ?? []).isEmpty;
    bool isFetchingMore =
        lazyLoadAsync.isLoading && (lazyLoadAsync.value ?? []).isNotEmpty;

    _scrollController.addListener(() {
      bool isBottom = _scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          _scrollController.position.outOfRange;
      if (isBottom && _hasMore && !isFetchingMore) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          ref.read(groomingTabLazyLoadProvider.notifier).fetchMore();
        });
      }
    });

    Widget content(List<OrderModel> orders) {
      int currentYear = 0;

      Widget item(OrderModel order) {
        return GestureDetector(
          onTap: () => showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) => GroomingBottomSheet(order.id),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            isScrollControlled: true,
          ),
          child: CardContainer(
            height: proportionateHeight(70),
            padding: EdgeInsets.symmetric(
              horizontal: proportionateWidth(16),
              vertical: proportionateHeight(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.items.length == 1
                      ? "1 Service"
                      : "${order.items.length} Services",
                  style: AppTextStyles.bodySemiBold(14, AppColors.grey800),
                ),
                SizedBox(height: proportionateHeight(4)),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: AppColors.grey400,
                    ),
                    SizedBox(width: proportionateWidth(4)),
                    Text(
                      order.dateRequired.format(),
                      style: AppTextStyles.bodyMedium(14, AppColors.grey600),
                    ),
                    SizedBox(width: proportionateWidth(6)),
                    Container(
                      height: proportionateHeight(15),
                      width: proportionateWidth(1),
                      color: AppColors.grey200,
                    ),
                    SizedBox(width: proportionateWidth(6)),
                    StreamBuilder<Staff>(
                      stream: ref
                          .read(staffRepositoryProvider)
                          .watch(order.staffId),
                      builder: (context, staffSnapshot) {
                        if (staffSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CupertinoActivityIndicator());
                        } else if (staffSnapshot.hasError) {
                          return Center(
                              child: Text('Error: ${staffSnapshot.error}'));
                        } else {
                          return Text(
                            'groomer ${staffSnapshot.data!.displayName}',
                            style:
                                AppTextStyles.bodyMedium(14, AppColors.grey600),
                          );
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }

      return ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: proportionateWidth(24),
          vertical: proportionateHeight(16),
        ),
        controller: _scrollController,
        itemCount: orders.length + (isFetchingMore ? 1 : 0),
        separatorBuilder: (context, index) => SizedBox(
          height: proportionateHeight(16),
        ),
        itemBuilder: (context, index) {
          if (orders.length == index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: proportionateHeight(30)),
              child: const CupertinoActivityIndicator(),
            );
          }

          final order = orders[index];

          if (currentYear != order.dateRequired.year) {
            currentYear = order.dateRequired.year;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: proportionateHeight(8)),
                Text(
                  currentYear.toString(),
                  style: AppTextStyles.bodySemiBold(16, AppColors.grey800),
                ),
                SizedBox(height: proportionateHeight(16)),
                item(order),
              ],
            );
          } else {
            return item(order);
          }
        },
      );
    }

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: isInitialFetching
            ? const Center(child: CupertinoActivityIndicator())
            : lazyLoadAsync.asData != null &&
                    (lazyLoadAsync.value ?? []).isEmpty
                // ? content(lazyLoadAsync.value!)
                // : emptyGroomingWidget(),
                ? emptyGroomingWidget()
                : content(lazyLoadAsync.value!),
      ),
    );
  }
}
