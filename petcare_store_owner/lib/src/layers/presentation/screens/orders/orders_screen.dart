import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:petcare_store_owner/src/common_widgets/custom_expansion_tile.dart';
import 'package:petcare_store_owner/src/constants/app_colors.dart';
import 'package:petcare_store_owner/src/constants/app_sizes.dart';
import 'package:petcare_store_owner/src/common_widgets/appbar_basic.dart';
import 'package:petcare_store_owner/src/constants/app_text_styles.dart';
import 'package:petcare_store_owner/src/layers/data/branch_repository.dart';
import 'package:petcare_store_owner/src/layers/data/grooming_repository.dart';
import 'package:petcare_store_owner/src/layers/data/insurance_repository.dart';
import 'package:petcare_store_owner/src/layers/data/pet_repository.dart';
import 'package:petcare_store_owner/src/layers/data/vaccine_repository.dart';
import 'package:petcare_store_owner/src/layers/domain/branch.dart';
import 'package:petcare_store_owner/src/layers/domain/order.dart';
import 'package:petcare_store_owner/src/layers/domain/pet.dart';
import 'package:petcare_store_owner/src/layers/presentation/screens/orders/orders_lazy_load.dart';
import 'package:petcare_store_owner/src/utils/datetime.dart';
import 'package:petcare_store_owner/src/utils/int.dart';

class OrdersScreen extends ConsumerWidget {
  OrdersScreen({super.key});

  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lazyLoadAsync = ref.watch(ordersLazyLoadProvider);
    bool _hasMore = ref.watch(ordersLazyLoadProvider.notifier).hasMore;
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
          ref.read(ordersLazyLoadProvider.notifier).fetchMore();
        });
      }
    });

    Widget orderListWidget(List<OrderModel> orders) {
      AutoDisposeProvider getItemRepo(String category) {
        if (category == 'Insurance') {
          return insuranceRepositoryProvider;
        } else if (category == 'Vaccine') {
          return vaccineRepositoryProvider;
        } else {
          return groomingRepositoryProvider;
        }
      }

      return ListView.separated(
        controller: _scrollController,
        itemCount: orders.length + (isFetchingMore ? 1 : 0),
        separatorBuilder: (context, index) => Container(
          height: proportionateHeight(5),
          margin: EdgeInsets.symmetric(vertical: proportionateHeight(10)),
          color: AppColors.grey300,
        ),
        itemBuilder: (context, index) {
          if (orders.length == index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: proportionateHeight(30)),
              child: const CupertinoActivityIndicator(),
            );
          }

          final order = orders[index];

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.itemCategory,
                      style: AppTextStyles.titleBold(18, AppColors.grey800),
                    ),
                    order.dateCompleted.isDefault()
                        ? order.staffId == ''
                            ? Text("Awaiting pet's arrival",
                                style: AppTextStyles.titleRegular(
                                    18, AppColors.yellow500))
                            : Text('In progress',
                                style: AppTextStyles.titleRegular(
                                    18, AppColors.green500))
                        : Text('Completed',
                            style: AppTextStyles.titleRegular(
                                18, AppColors.blue500))
                  ],
                ),
                Divider(thickness: 1, color: AppColors.grey200),
                CustomExpansionTile(
                    visualDensity: const VisualDensity(
                        vertical: VisualDensity.minimumDensity),
                    title:
                        order.itemCategory == 'Grooming' ? 'Services' : 'Items',
                    children: order.items
                        .map((itemId) => StreamBuilder<dynamic>(
                              stream: ref
                                  .read(getItemRepo(order.itemCategory))
                                  .watch(itemId),
                              builder: (context, itemSnapshot) {
                                if (itemSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CupertinoActivityIndicator();
                                } else if (itemSnapshot.hasError) {
                                  return Text('Error: ${itemSnapshot.error}');
                                } else {
                                  final item = itemSnapshot.data!;
                                  return _ItemTile(
                                    photoURL: item.photoURL,
                                    name: item.name,
                                    price: item.price,
                                  );
                                }
                              },
                            ))
                        .toList()),
                Divider(thickness: 1, color: AppColors.grey200),
                CustomExpansionTile(
                  visualDensity: const VisualDensity(
                      vertical: VisualDensity.minimumDensity),
                  initiallyExpanded: false,
                  title: 'Details',
                  children: [
                    StreamBuilder<Branch>(
                      stream: ref
                          .read(branchRepositoryProvider)
                          .watchBranch(order.branchId),
                      builder: (context, branchSnapshot) {
                        if (branchSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CupertinoActivityIndicator();
                        } else if (branchSnapshot.hasError) {
                          return Text('Error: ${branchSnapshot.error}');
                        } else {
                          return _DetailTile(
                            title: 'Branch',
                            value: branchSnapshot.data!.name,
                          );
                        }
                      },
                    ),
                    StreamBuilder<Pet>(
                      stream:
                          ref.read(petRepositoryProvider).watchPet(order.petId),
                      builder: (context, petSnapshot) {
                        if (petSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CupertinoActivityIndicator();
                        } else if (petSnapshot.hasError) {
                          return const _DetailTile(
                              title: 'Pet', value: 'Deleted by the pet owner');
                        } else {
                          return _DetailTile(
                              title: 'Pet', value: petSnapshot.data!.name);
                        }
                      },
                    ),
                    _DetailTile(
                      title: 'Required on',
                      value: DateFormat('d MMMM y').format(order.dateRequired),
                    ),
                    if (!order.dateCompleted.isDefault())
                      _DetailTile(
                        title: 'Completed on',
                        value:
                            DateFormat('d MMMM y').format(order.dateCompleted),
                      )
                  ],
                ),
                Divider(thickness: 1, color: AppColors.grey200),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: proportionateHeight(5)),
                  child: Row(
                    children: [
                      Expanded(
                        child: order.paid
                            ? Text(
                                'Paid',
                                style: AppTextStyles.bodySemiBold(
                                    16, AppColors.green500),
                              )
                            : Text(
                                'Unpaid',
                                style: AppTextStyles.bodySemiBold(
                                    16, AppColors.red500),
                              ),
                      ),
                      Text(
                        'Total: ',
                        style:
                            AppTextStyles.bodySemiBold(16, AppColors.grey800),
                      ),
                      Text(
                        order.total.toVND(),
                        style:
                            AppTextStyles.bodySemiBold(16, AppColors.grey1000),
                      ),
                    ],
                  ),
                ),
              ],
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
            const BasicAppBar(title: 'Orders'),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: proportionateWidth(24),
                vertical: proportionateHeight(16),
              ),
              child: const CupertinoSearchTextField(
                placeholder: 'Search by Order ID',
              ),
            ),

            Expanded(
                child: isInitialFetching
                    ? const Center(child: CupertinoActivityIndicator())
                    : lazyLoadAsync.asData != null &&
                            (lazyLoadAsync.value ?? []).isEmpty
                        ? const Center(child: Text('Your store has no order!'))
                        : orderListWidget(lazyLoadAsync.value!)),
          ],
        ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final String title;
  final String value;

  const _DetailTile({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity:
          const VisualDensity(vertical: VisualDensity.minimumDensity),
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          Text(
            '$title: ',
            style: AppTextStyles.bodyRegular(14, AppColors.grey700),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: AppTextStyles.bodyMedium(14, AppColors.grey800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  final String photoURL;
  final String name;
  final int price;

  const _ItemTile({
    Key? key,
    required this.photoURL,
    required this.name,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity:
          const VisualDensity(vertical: VisualDensity.minimumDensity),
      contentPadding: EdgeInsets.zero,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.network(
            photoURL,
            width: proportionateWidth(65),
            height: proportionateHeight(50),
            fit: BoxFit.fill,
            filterQuality: FilterQuality.high,
          ),
          SizedBox(width: proportionateWidth(10)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                name,
                style: AppTextStyles.bodySemiBold(14, AppColors.grey800),
              ),
              Text(
                price.toVND(),
                style: AppTextStyles.bodyRegular(14, AppColors.grey700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
