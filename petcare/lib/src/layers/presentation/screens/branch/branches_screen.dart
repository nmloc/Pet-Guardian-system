import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:petcare/src/layers/application/location_service.dart';
import 'package:petcare/src/layers/presentation/common_widgets/card_container.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/layers/presentation/common_widgets/appbar_basic.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/domain/branch.dart';
import 'package:petcare/src/layers/presentation/screens/branch/branches_lazy_load.dart';
import 'package:petcare/src/routing/app_router.dart';

class BranchesScreen extends ConsumerWidget {
  BranchesScreen({super.key});

  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lazyLoadAsync = ref.watch(branchesLazyLoadProvider);
    bool _hasMore = ref.watch(branchesLazyLoadProvider.notifier).hasMore;
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
          ref.read(branchesLazyLoadProvider.notifier).fetchMore();
        });
      }
    });

    Widget content(List<Branch> branches) {
      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
        controller: _scrollController,
        itemCount: branches.length + (isFetchingMore ? 1 : 0),
        separatorBuilder: (context, index) => SizedBox(
          height: proportionateHeight(10),
        ),
        itemBuilder: (context, index) {
          if (branches.length == index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: proportionateHeight(30)),
              child: const CupertinoActivityIndicator(),
            );
          }

          final branch = branches[index];

          return GestureDetector(
            onTap: () => context.goNamed(
              AppRoute.branchDetail.name,
              pathParameters: {"branchId": branch.id},
            ),
            child: CardContainer(
              height: proportionateWidth(100),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(
                    "https://firebasestorage.googleapis.com/v0/b/pet-care-b0d24.appspot.com/o/pet-guardian-icon.png?alt=media&token=f4d29c98-2034-4a2b-8900-af92a6d9f16d",
                    fit: BoxFit.fill,
                    filterQuality: FilterQuality.high,
                    height: proportionateHeight(65),
                    width: proportionateWidth(56),
                  ),
                  SizedBox(width: proportionateWidth(10)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        branch.name,
                        style:
                            AppTextStyles.bodySemiBold(16, AppColors.grey800),
                      ),
                      SizedBox(height: proportionateHeight(2)),
                      SizedBox(
                        width: proportionateWidth(230),
                        child: Text(
                          branch.address(),
                          style:
                              AppTextStyles.bodyRegular(14, AppColors.grey600),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 18,
                            color: AppColors.grey700,
                          ),
                          SizedBox(width: proportionateWidth(4)),
                          ref.watch(locationServiceProvider).when(
                                data: (data) => data == null
                                    ? SizedBox(
                                        width: proportionateWidth(150),
                                        child: Text(
                                          "Please grant location permission",
                                          style: AppTextStyles.bodyRegular(
                                              14, AppColors.grey600),
                                        ),
                                      )
                                    : Text(
                                        "${const Distance().as(
                                          LengthUnit.Kilometer,
                                          LatLng(
                                            branch.lat_long.latitude,
                                            branch.lat_long.longitude,
                                          ),
                                          LatLng(
                                            data.latitude!,
                                            data.longitude!,
                                          ),
                                        )} km",
                                        style: AppTextStyles.bodyRegular(
                                          14,
                                          AppColors.grey600,
                                        ),
                                      ),
                                loading: () =>
                                    const CupertinoActivityIndicator(),
                                error: (error, stackTrace) => SizedBox(
                                  width: proportionateWidth(150),
                                  child: Text(
                                    error.toString(),
                                    style: AppTextStyles.bodyRegular(
                                        14, AppColors.grey600),
                                  ),
                                ),
                              )
                        ],
                      ),
                    ],
                  ),
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
            const BasicAppBar(title: 'Stores'),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: proportionateWidth(24),
                vertical: proportionateHeight(16),
              ),
              child: const CupertinoSearchTextField(
                placeholder: "Search by store's name",
              ),
            ),

            Expanded(
              child: isInitialFetching
                  ? const Center(child: CupertinoActivityIndicator())
                  : lazyLoadAsync.asData != null &&
                          (lazyLoadAsync.value ?? []).isEmpty
                      ? const Center(child: Text('There is no store!'))
                      : content(lazyLoadAsync.value!),
            ),
          ],
        ),
      ),
    );
  }
}
