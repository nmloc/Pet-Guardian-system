import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare/src/layers/presentation/common_widgets/appbar_with_pet.dart';
import 'package:petcare/src/layers/presentation/common_widgets/card_container.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/domain/vaccine.dart';
import 'package:petcare/src/routing/app_router.dart';
import 'package:petcare/src/utils/int.dart';

import 'vaccines_lazy_load.dart';

class VaccinesScreen extends ConsumerWidget {
  VaccinesScreen({super.key});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lazyLoadAsync = ref.watch(vaccinesLazyLoadProvider);
    bool _hasMore = ref.watch(vaccinesLazyLoadProvider.notifier).hasMore;
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
          ref.read(vaccinesLazyLoadProvider.notifier).fetchMore();
        });
      }
    });

    Widget content(List<Vaccine> vaccines) {
      return GridView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 155.5 / 174,
        ),
        shrinkWrap: true,
        itemCount: vaccines.length + (isFetchingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (vaccines.length == index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: proportionateHeight(30)),
              child: const CupertinoActivityIndicator(),
            );
          }

          final vaccine = vaccines[index];

          return GestureDetector(
            onTap: () => context.goNamed(
              AppRoute.vaccineDetail.name,
              pathParameters: {'vaccineId': vaccine.id},
            ),
            child: CardContainer(
              height: proportionateWidth(100),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      vaccine.photoURL,
                      height: proportionateHeight(90),
                      width: proportionateWidth(90),
                    ),
                  ),
                  Text(
                    vaccine.name,
                    style: AppTextStyles.bodySemiBold(14, AppColors.grey800),
                    maxLines: 2,
                  ),
                  SizedBox(height: proportionateHeight(6)),
                  Row(
                    children: [
                      Text(
                        vaccine.price.formatPrice(),
                        style: AppTextStyles.bodyRegular(14, AppColors.grey700),
                      ),
                      SizedBox(width: proportionateWidth(4)),
                      Text(
                        'VND',
                        style:
                            AppTextStyles.bodySemiBold(14, AppColors.grey800),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Section 1 - Custom Appbar
            AppBarWithPet(
              service: 'Vaccines',
              isPetProfile: false,
              isAbleToChangePet: false,
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: proportionateWidth(24),
                vertical: proportionateHeight(16),
              ),
              child: const CupertinoSearchTextField(
                placeholder: "Search by Vaccine's name",
              ),
            ),

            Expanded(
                child: isInitialFetching
                    ? const Center(child: CupertinoActivityIndicator())
                    : lazyLoadAsync.asData != null &&
                            (lazyLoadAsync.value ?? []).isEmpty
                        ? const Center(child: Text('There is no vaccine!'))
                        : content(lazyLoadAsync.value!)),
          ],
        ),
      ),
    );
  }
}
