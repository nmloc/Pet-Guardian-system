import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:petcare_store_owner/src/common_widgets/appbar_dropdown.dart';
import 'package:petcare_store_owner/src/common_widgets/card_container.dart';
import 'package:petcare_store_owner/src/constants/app_colors.dart';
import 'package:petcare_store_owner/src/constants/app_sizes.dart';
import 'package:petcare_store_owner/src/constants/app_text_styles.dart';
import 'package:petcare_store_owner/src/layers/data/vaccine_repository.dart';
import 'package:petcare_store_owner/src/layers/domain/grooming_service.dart';
import 'package:petcare_store_owner/src/layers/domain/insurance.dart';
import 'package:petcare_store_owner/src/layers/domain/vaccine.dart';
import 'package:petcare_store_owner/src/layers/presentation/screens/inventory/insurance_lazy_load.dart';
import 'package:petcare_store_owner/src/utils/int.dart';

import 'components/bottom_sheet_content.dart';
import 'grooming_lazy_load.dart';
import 'vaccine_lazy_load.dart';

List<String> _categories = ['Insurance', 'Vaccine', 'Grooming'];
final _categoryProvider =
    StateProvider.autoDispose<String>((ref) => _categories[0]);

class InventoryScreen extends ConsumerStatefulWidget {
  InventoryScreen({super.key});

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _insuranceScrollController;
  late ScrollController _vaccineScrollController;
  late ScrollController _groomingScrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: _categories.length,
      animationDuration: Duration.zero,
    );
    _insuranceScrollController = ScrollController();
    _vaccineScrollController = ScrollController();
    _groomingScrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _insuranceScrollController.dispose();
    _vaccineScrollController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String currentSpeciesInsuranceTab = '';
    Widget lazyLoadWidget(String name) {
      AsyncValue lazyLoadAsync;
      ScrollController scrollController;
      bool isInitialFetching;
      bool isFetchingMore;
      if (name == 'Insurance') {
        scrollController = _insuranceScrollController;
        lazyLoadAsync = ref.watch(insuranceLazyLoadProvider);
        isInitialFetching =
            lazyLoadAsync.isLoading && (lazyLoadAsync.value ?? []).isEmpty;
        isFetchingMore =
            lazyLoadAsync.isLoading && (lazyLoadAsync.value ?? []).isNotEmpty;
        _insuranceScrollController.addListener(() {
          bool isBottom = _insuranceScrollController.offset >=
                  _insuranceScrollController.position.maxScrollExtent &&
              _insuranceScrollController.position.outOfRange;
          if (isBottom &&
              ref.watch(insuranceLazyLoadProvider.notifier).hasMore &&
              !isFetchingMore) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              ref.read(insuranceLazyLoadProvider.notifier).fetchMore();
            });
          }
        });
      } else if (name == 'Vaccine') {
        scrollController = _vaccineScrollController;
        lazyLoadAsync = ref.watch(vaccineLazyLoadProvider);
        isInitialFetching =
            lazyLoadAsync.isLoading && (lazyLoadAsync.value ?? []).isEmpty;
        isFetchingMore =
            lazyLoadAsync.isLoading && (lazyLoadAsync.value ?? []).isNotEmpty;
        _vaccineScrollController.addListener(() {
          bool isBottom = _vaccineScrollController.offset >=
                  _vaccineScrollController.position.maxScrollExtent &&
              _vaccineScrollController.position.outOfRange;
          if (isBottom &&
              ref.watch(vaccineLazyLoadProvider.notifier).hasMore &&
              !isFetchingMore) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              ref.read(vaccineLazyLoadProvider.notifier).fetchMore();
            });
          }
        });
      } else {
        scrollController = _groomingScrollController;
        lazyLoadAsync = ref.watch(groomingLazyLoadProvider);
        isInitialFetching =
            lazyLoadAsync.isLoading && (lazyLoadAsync.value ?? []).isEmpty;
        isFetchingMore =
            lazyLoadAsync.isLoading && (lazyLoadAsync.value ?? []).isNotEmpty;
        _groomingScrollController.addListener(() {
          bool isBottom = _groomingScrollController.offset >=
                  _groomingScrollController.position.maxScrollExtent &&
              _groomingScrollController.position.outOfRange;
          if (isBottom &&
              ref.watch(groomingLazyLoadProvider.notifier).hasMore &&
              !isFetchingMore) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              ref.read(groomingLazyLoadProvider.notifier).fetchMore();
            });
          }
        });
      }

      Widget insuranceItem(Insurance item) {
        return Dismissible(
          key: Key(item.id),
          background:
              CardContainer(background: AppColors.red500, enableShadow: false),
          // onDismissed: (direction) => ref
          //     .read(insuranceRepositoryProvider)
          //     .deletePack(item.id, item.photoURL)
          //     .then(
          //       (_) => Fluttertoast.showToast(
          //           msg: '${item.name} removed!',
          //           backgroundColor: AppColors.blue500),
          //     ),
          child: CardContainer(
            enableShadow: true,
            child: Row(
              children: [
                Container(
                    height: proportionateHeight(64),
                    width: proportionateWidth(64),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    child: Image.network(item.photoURL)),
                SizedBox(width: proportionateWidth(12)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name,
                        style: AppTextStyles.bodyBold(16, AppColors.grey800)),
                    SizedBox(height: proportionateHeight(2)),
                    Row(
                      children: [
                        Text(
                          'VND',
                          style:
                              AppTextStyles.bodyMedium(14, AppColors.grey400),
                        ),
                        SizedBox(width: proportionateWidth(4)),
                        Text(item.price.formatPrice(),
                            style: AppTextStyles.bodyMedium(
                                14, AppColors.grey600)),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }

      Widget vaccineItem(Vaccine item) {
        return Dismissible(
          key: Key(item.id),
          background:
              CardContainer(background: AppColors.red500, enableShadow: false),
          onDismissed: (direction) => ref
              .read(vaccineRepositoryProvider)
              .deleteVaccine(item.id, item.photoURL)
              .then(
                (_) => Fluttertoast.showToast(
                    msg: '${item.name} removed!',
                    backgroundColor: AppColors.blue500),
              ),
          child: CardContainer(
            enableShadow: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: proportionateHeight(52),
                    width: proportionateWidth(52),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    child: Image.network(item.photoURL)),
                SizedBox(width: proportionateWidth(12)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.name,
                        style: AppTextStyles.bodyBold(16, AppColors.grey800)),
                    SizedBox(height: proportionateHeight(2)),
                    Row(
                      children: [
                        Text(
                          'VND',
                          style:
                              AppTextStyles.bodyRegular(14, AppColors.grey400),
                        ),
                        SizedBox(width: proportionateWidth(4)),
                        SizedBox(
                          width: proportionateWidth(50),
                          child: Text(item.price.formatPrice(),
                              style: AppTextStyles.bodyMedium(
                                  14, AppColors.grey600)),
                        ),
                        SizedBox(width: proportionateWidth(6)),
                        Container(
                          width: proportionateWidth(1),
                          height: proportionateHeight(14),
                          decoration: BoxDecoration(color: AppColors.grey400),
                        ),
                        SizedBox(width: proportionateWidth(6)),
                        FaIcon(FontAwesomeIcons.gears,
                            size: 14, color: AppColors.grey400),
                        SizedBox(width: proportionateWidth(4)),
                        SizedBox(
                          width: AppSizes.screenWidth / 3.5,
                          child: Text(item.manufacturer,
                              style: AppTextStyles.bodyMedium(
                                  14, AppColors.grey600)),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }

      Widget groomingItem(GroomingService item) {
        return Dismissible(
          key: Key(item.id),
          background:
              CardContainer(background: AppColors.red500, enableShadow: false),
          // onDismissed: (direction) => ref
          //     .read(vaccineRepositoryProvider)
          //     .deleteVaccine(item.id, item.photoURL)
          //     .then(
          //       (_) => Fluttertoast.showToast(
          //           msg: '${item.name} removed!',
          //           backgroundColor: AppColors.blue500),
          //     ),
          child: CardContainer(
            enableShadow: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: proportionateHeight(52),
                    width: proportionateWidth(52),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    child: Image.network(item.photoURL)),
                SizedBox(width: proportionateWidth(12)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.name,
                        style: AppTextStyles.bodyBold(16, AppColors.grey800)),
                    SizedBox(height: proportionateHeight(2)),
                    Row(
                      children: [
                        Text(
                          'VND',
                          style:
                              AppTextStyles.bodyRegular(14, AppColors.grey400),
                        ),
                        SizedBox(width: proportionateWidth(4)),
                        Text(item.price.formatPrice(),
                            style: AppTextStyles.bodyMedium(
                                14, AppColors.grey600)),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }

      return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: proportionateWidth(24),
              vertical: proportionateHeight(16),
            ),
            child: const CupertinoSearchTextField(
              placeholder: 'Search by Vaccine name',
            ),
          ),
          Expanded(
            child: isInitialFetching
                ? const Center(child: CupertinoActivityIndicator())
                : lazyLoadAsync.asData != null &&
                        (lazyLoadAsync.value ?? []).isEmpty
                    ? const Center(
                        child: Text('Your store has no grooming service!'))
                    : ListView.separated(
                        padding: EdgeInsets.symmetric(
                            horizontal: proportionateWidth(24)),
                        controller: scrollController,
                        itemCount: lazyLoadAsync.value!.length +
                            (isFetchingMore ? 1 : 0),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: proportionateHeight(16)),
                        itemBuilder: (_, index) {
                          List<dynamic> items = lazyLoadAsync.value!;
                          if (items.length == index) {
                            return Padding(
                              padding:
                                  EdgeInsets.only(top: proportionateHeight(24)),
                              child: const CupertinoActivityIndicator(),
                            );
                          }

                          if (name == 'Insurance') {
                            if (currentSpeciesInsuranceTab !=
                                items[index].species) {
                              currentSpeciesInsuranceTab = items[index].species;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(currentSpeciesInsuranceTab,
                                      style: AppTextStyles.bodySemiBold(
                                          16, AppColors.grey800)),
                                  SizedBox(height: proportionateHeight(16)),
                                  insuranceItem(items[index]),
                                ],
                              );
                            }

                            return insuranceItem(items[index]);
                          } else if (name == 'Vaccine') {
                            return vaccineItem(items[index]);
                          } else {
                            return groomingItem(items[index]);
                          }
                        },
                      ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: DropdownAppBar(
        items: _categories,
        currentItem: ref.watch(_categoryProvider),
        onChanged: (value) {
          ref.read(_categoryProvider.notifier).state = value!;
          _tabController.animateTo(_categories.indexOf(value));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCupertinoModalBottomSheet(
          backgroundColor: AppColors.grey100,
          elevation: 8,
          expand: true,
          enableDrag: false,
          context: context,
          builder: (context) =>
              BottomSheetContent(ref.watch(_categoryProvider)),
        ),
        child: const Icon(CupertinoIcons.add),
      ),
      body: SafeArea(
        bottom: false,
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: <Widget>[
            lazyLoadWidget('Insurance'),
            lazyLoadWidget('Vaccine'),
            lazyLoadWidget('Grooming'),
          ],
        ),
      ),
    );
  }
}
