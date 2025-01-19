import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petcare_staff/src/layers/data/pet_repository.dart';
import 'package:petcare_staff/src/layers/domain/pet.dart';
import 'package:petcare_staff/src/layers/presentation/common_widgets/appbar_basic.dart';
import 'package:petcare_staff/src/layers/presentation/common_widgets/card_container.dart';
import 'package:petcare_staff/src/constants/app_colors.dart';
import 'package:petcare_staff/src/constants/app_sizes.dart';
import 'package:petcare_staff/src/constants/app_text_styles.dart';
import 'package:petcare_staff/src/layers/domain/order.dart';
import 'package:petcare_staff/src/layers/presentation/common_widgets/task_bottom_sheet.dart';
import 'package:petcare_staff/src/utils/datetime.dart';

import 'tasks_lazy_load.dart';

class TasksScreen extends ConsumerWidget {
  TasksScreen({super.key});

  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget emptyVaccineWidget() {
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
                    "No vaccination used",
                    style: AppTextStyles.titleBold(26, AppColors.grey800),
                  ),
                  SizedBox(height: proportionateHeight(10)),
                  Text(
                    "Our vaccines can help reimburse vet bills related to injuries and illnesses, helping provide a financial safety net for unplanned circumstances.",
                    style: AppTextStyles.bodyMedium(16, AppColors.grey600),
                    textAlign: TextAlign.center,
                    maxLines: 5,
                  ),
                  SizedBox(height: proportionateHeight(36)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final lazyLoadAsync = ref.watch(tasksLazyLoadProvider);
    bool _hasMore = ref.watch(tasksLazyLoadProvider.notifier).hasMore;
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
          ref.read(tasksLazyLoadProvider.notifier).fetchMore();
        });
      }
    });

    Widget content(List<OrderModel> orders) {
      int currentYear = 0;

      Widget item(OrderModel order) {
        return GestureDetector(
          onTap: () => showModalBottomSheet(
            context: context,
            builder: (BuildContext context) => TaskBottomSheet(order.id),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            isScrollControlled: true,
          ),
          child: CardContainer(
            height: proportionateWidth(100),
            padding: EdgeInsets.symmetric(
              horizontal: proportionateWidth(16),
              vertical: proportionateHeight(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                order.dateCompleted.isDefault()
                    ? Text(
                        order.itemCategory,
                        style:
                            AppTextStyles.bodySemiBold(14, AppColors.grey800),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            order.itemCategory,
                            style: AppTextStyles.bodySemiBold(
                                14, AppColors.grey800),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.blue500,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            padding: const EdgeInsets.all(2),
                            child: Icon(
                              CupertinoIcons.checkmark,
                              color: AppColors.grey0,
                              size: 14,
                            ),
                          )
                        ],
                      ),
                SizedBox(height: proportionateHeight(4)),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: AppColors.grey400,
                    ),
                    SizedBox(width: proportionateWidth(6)),
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
                    StreamBuilder<Pet>(
                      stream:
                          ref.read(petRepositoryProvider).watchPet(order.petId),
                      builder: (context, petSnapshot) {
                        if (petSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CupertinoActivityIndicator());
                        } else if (petSnapshot.hasError) {
                          return Center(
                              child: Text('Error: ${petSnapshot.error}'));
                        } else {
                          Pet pet = petSnapshot.data!;
                          return Row(
                            children: [
                              Icon(
                                pet.species == 'Feline'
                                    ? FontAwesomeIcons.cat
                                    : FontAwesomeIcons.dog,
                                size: 16,
                                color: AppColors.grey400,
                              ),
                              SizedBox(width: proportionateWidth(6)),
                              Text(
                                pet.name,
                                style: AppTextStyles.bodyMedium(
                                    14, AppColors.grey600),
                              ),
                            ],
                          );
                        }
                      },
                    )
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
        child: Column(
          children: [
            const BasicAppBar(title: 'Tasks'),
            Expanded(
              child: isInitialFetching
                  ? const Center(child: CupertinoActivityIndicator())
                  : lazyLoadAsync.asData != null &&
                          (lazyLoadAsync.value ?? []).isEmpty
                      ? emptyVaccineWidget()
                      : content(lazyLoadAsync.value!),
            ),
          ],
        ),
      ),
    );
  }
}
