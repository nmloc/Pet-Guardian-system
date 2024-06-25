import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare_store_owner/src/common_widgets/color_dot.dart';
import 'package:petcare_store_owner/src/constants/app_colors.dart';
import 'package:petcare_store_owner/src/constants/app_sizes.dart';
import 'package:petcare_store_owner/src/constants/app_text_styles.dart';
import 'package:petcare_store_owner/src/layers/data/auth_repository.dart';
import 'package:petcare_store_owner/src/layers/data/order_repository.dart';
import 'package:petcare_store_owner/src/layers/domain/order.dart';
import 'package:petcare_store_owner/src/layers/presentation/screens/dashboard/components/drawer.dart';
import 'package:petcare_store_owner/src/layers/presentation/screens/dashboard/dashboard_screen_controller.dart';
import 'package:petcare_store_owner/src/routing/app_router.dart';
import 'package:petcare_store_owner/src/utils/int.dart';
import 'components/menu_card.dart';

// ignore: must_be_immutable
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
      stream: ref.watch(orderRepositoryProvider).watchOrders(),
      builder: (BuildContext context, AsyncSnapshot orderSnapshot) {
        if (orderSnapshot.connectionState == ConnectionState.waiting) {
          return const CupertinoActivityIndicator();
        } else if (orderSnapshot.hasError) {
          return Center(child: Text('Error: ${orderSnapshot.error}'));
        } else {
          final List<OrderModel> orderList = orderSnapshot.data;
          int grossSales = 0;
          for (var order in orderList) {
            grossSales += order.total;
          }
          List<Map<String, dynamic>> menuList = [
            {
              'title': 'Staffs',
              'color': AppColors.blue500,
              'icon': FontAwesomeIcons.userGroup,
              'onTap': () => context.goNamed(AppRoute.staffs.name),
            },
            {
              'title': 'Gross Sales',
              'color': AppColors.green500,
              'icon': FontAwesomeIcons.moneyBill,
              'value': grossSales.formatPrice(),
              'onTap': () => context.goNamed(AppRoute.orders.name),
            },
            {
              'title': 'Forecast Demand',
              'color': AppColors.purple500,
              'icon': FontAwesomeIcons.atom,
              'onTap': () => context.goNamed(AppRoute.demandForecast.name),
            },
            {
              'title': 'Inventory',
              'color': AppColors.orange500,
              'icon': FontAwesomeIcons.boxOpen,
              'onTap': () => context.goNamed(AppRoute.inventory.name),
            },
          ];

          return ZoomDrawer(
            menuScreen: DrawerWidget(),
            mainScreen: Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    // Section 1 - Custom Appbar
                    const DashboardAppBar(),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                            horizontal: proportionateWidth(24)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: proportionateHeight(12)),
                              child: Text('This month',
                                  style: AppTextStyles.bodySemiBold(
                                      16, AppColors.grey800)),
                            ),
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16.0,
                                mainAxisSpacing: 16.0,
                              ),
                              shrinkWrap: true,
                              itemCount: menuList.length,
                              itemBuilder: (context, index) {
                                return MenuCard(
                                  title: menuList[index]['title'],
                                  color: menuList[index]['color'],
                                  icon: menuList[index]['icon'],
                                  value: menuList[index]['value'],
                                  onTap: menuList[index]['onTap'],
                                );
                              },
                            ),

                            // Padding(
                            //   padding: EdgeInsets.symmetric(
                            //       vertical: proportionateHeight(24)),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     mainAxisSize: MainAxisSize.min,
                            //     children: [
                            //       Text('Health',
                            //           style: AppTextStyles.bodySemiBold(
                            //               16, AppColors.grey800)),
                            //       Wrap(
                            //         spacing: 16,
                            //         children: [
                            //           {
                            //             'title': 'Insurance',
                            //             'color': AppColors.blue700,
                            //           },
                            //           {
                            //             'title': 'Vaccine',
                            //             'color': AppColors.blue500,
                            //           },
                            //           {
                            //             'title': 'Activities',
                            //             'color': AppColors.blue500,
                            //           }
                            //         ]
                            //             .map(
                            //               (item) => ChartDescriptionItem(
                            //                 item['color'] as Color,
                            //                 item['title'] as String,
                            //               ),
                            //             )
                            //             .toList(),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // BarChartWidget()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            style: DrawerStyle.style2,
            controller: ref.watch(zDrawerProvider),
            mainScreenScale: 0.0,
            slideWidth: AppSizes.screenWidth * 0.8,
            menuScreenWidth: AppSizes.screenWidth,
            borderRadius: 40.0,
            angle: 0,
            dragOffset: AppSizes.screenWidth * 0.2,
          );
        }
      },
    );
  }
}

class DashboardAppBar extends ConsumerWidget {
  const DashboardAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(ref
                          .read(authRepositoryProvider)
                          .currentUser!
                          .photoURL!),
                    ),
                    onTap: () {},
                  ),
                  SizedBox(
                    width: proportionateWidth(10),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello,',
                          style:
                              AppTextStyles.bodyRegular(14, AppColors.grey600)),
                      Text(
                          ref
                              .read(authRepositoryProvider)
                              .currentUser!
                              .displayName!
                              .split(' ')[0],
                          style: AppTextStyles.bodySemiBold(
                              16, AppColors.grey800)),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      size: 24,
                      color: AppColors.grey700,
                    ),
                    onPressed: () => ref.read(zDrawerProvider).toggle!.call(),
                  ),
                  Container(
                    width: 1,
                    height: proportionateHeight(19),
                    color: AppColors.grey300,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      size: 24,
                      color: AppColors.grey700,
                    ),
                    onPressed: () => ref.read(zDrawerProvider).toggle!.call(),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: proportionateHeight(12)),

          // Custom fade out divider
          SizedBox(
            height: 1.0,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent,
                          AppColors.radial,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChartDescriptionItem extends StatelessWidget {
  final Color color;
  final String title;
  const ChartDescriptionItem(this.color, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ColorDot(color, 5),
        SizedBox(width: proportionateWidth(5)),
        Text(title, style: AppTextStyles.bodyRegular(14, AppColors.grey700)),
      ],
    );
  }
}
