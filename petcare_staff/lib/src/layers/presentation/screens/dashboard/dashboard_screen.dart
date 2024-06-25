import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare_staff/src/constants/app_colors.dart';
import 'package:petcare_staff/src/constants/app_sizes.dart';
import 'package:petcare_staff/src/constants/app_text_styles.dart';
import 'package:petcare_staff/src/layers/data/auth_repository.dart';
import 'package:petcare_staff/src/layers/data/order_repository.dart';
import 'package:petcare_staff/src/layers/data/pet_repository.dart';
import 'package:petcare_staff/src/layers/domain/order.dart';
import 'package:petcare_staff/src/layers/domain/pet.dart';
import 'package:petcare_staff/src/layers/presentation/common_widgets/task_bottom_sheet.dart';
import 'package:petcare_staff/src/layers/presentation/screens/dashboard/components/drawer.dart';
import 'package:petcare_staff/src/layers/presentation/screens/dashboard/dashboard_screen_controller.dart';
import 'package:petcare_staff/src/routing/app_router.dart';
import 'package:petcare_staff/src/utils/color.dart';
import 'components/menu_card.dart';

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
          List<Map<String, dynamic>> menuList = [
            // {
            //   'title': 'Inventory',
            //   'color': AppColors.orange500,
            //   'icon': FontAwesomeIcons.boxOpen,
            //   'onTap': () => context.goNamed(AppRoute.inventory.name),
            // },
            {
              'title': 'All tasks',
              'color': AppColors.blue500,
              'icon': FontAwesomeIcons.listCheck,
              'value': orderList.length.toString(),
              'onTap': () => context.goNamed(AppRoute.tasks.name),
            },
          ];

          return ZoomDrawer(
            menuScreen: DrawerWidget(),
            mainScreen: Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    // Section 1 - Custom Appbar
                    const _DashboardAppBar(),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                            horizontal: proportionateWidth(24)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _CurrentTaskWidget(),
                            SizedBox(height: proportionateHeight(30)),
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

class _DashboardAppBar extends ConsumerWidget {
  const _DashboardAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User user = ref.read(authRepositoryProvider).currentUser!;
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
                      backgroundImage: NetworkImage(user.photoURL!),
                    ),
                    onTap: () => context.goNamed(AppRoute.userProfile.name),
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
                      Text(user.displayName!.split(' ')[0],
                          style: AppTextStyles.bodySemiBold(
                              16, AppColors.grey800)),
                    ],
                  ),
                ],
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

class _CurrentTaskWidget extends ConsumerWidget {
  const _CurrentTaskWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
      stream: ref.read(orderRepositoryProvider).watchAvailableOrders(),
      builder: (context, taskSnapshot) {
        if (taskSnapshot.connectionState == ConnectionState.waiting) {
          return const CupertinoActivityIndicator();
        } else if (taskSnapshot.hasError) {
          print(taskSnapshot.error);
          return Center(child: Text('Error: ${taskSnapshot.error}'));
        } else {
          List<OrderModel> taskList = taskSnapshot.data!;

          return taskList.isEmpty
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: proportionateHeight(16)),
                    Text('Your current task',
                        style:
                            AppTextStyles.bodySemiBold(16, AppColors.grey800)),
                    SizedBox(height: proportionateHeight(16)),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: proportionateHeight(155),
                        viewportFraction: 1,
                        enableInfiniteScroll: false,
                      ),
                      items: taskList
                          .map(
                            (task) => StreamBuilder<OrderModel>(
                              stream: ref
                                  .read(orderRepositoryProvider)
                                  .watch(task.id),
                              builder: (context, orderSnapshot) {
                                if (orderSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CupertinoActivityIndicator();
                                } else if (orderSnapshot.hasError) {
                                  return Center(
                                      child: Text(
                                          'Error: ${orderSnapshot.error}'));
                                } else {
                                  OrderModel task = orderSnapshot.data!;
                                  return GestureDetector(
                                    onTap: () => showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          TaskBottomSheet(task.id),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(26)),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      isScrollControlled: true,
                                    ),
                                    child: Container(
                                      width: proportionateWidth(327),
                                      padding: EdgeInsets.symmetric(
                                        vertical: proportionateHeight(15),
                                        horizontal: proportionateWidth(20),
                                      ),
                                      margin: const EdgeInsets.only(
                                          right: 25, bottom: 25),
                                      decoration: BoxDecoration(
                                        color: AppColors.blue500,
                                        border: Border.all(
                                            color: AppColors.grey100),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(14)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: HexColor('CCE1F7'),
                                            spreadRadius: 1,
                                            offset: const Offset(12.5, 12.5),
                                          ),
                                          BoxShadow(
                                            color: HexColor('CCE1F7')
                                                .withOpacity(0.3),
                                            spreadRadius: 1,
                                            offset: const Offset(25, 25),
                                          ),
                                        ],
                                      ),
                                      child: StreamBuilder<Pet>(
                                        stream: ref
                                            .read(petRepositoryProvider)
                                            .watchPet(task.petId),
                                        builder: (context, petSnapshot) {
                                          if (petSnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CupertinoActivityIndicator();
                                          } else if (petSnapshot.hasError) {
                                            return Center(
                                                child: Text(
                                                    'Error: ${petSnapshot.error}'));
                                          } else {
                                            Pet pet = petSnapshot.data!;
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      task.itemCategory,
                                                      style: AppTextStyles
                                                          .bodySemiBold(20,
                                                              AppColors.grey0),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            proportionateHeight(
                                                                5)),
                                                    Text(
                                                      '${pet.name} | ${pet.species}',
                                                      style: AppTextStyles
                                                          .bodyRegular(
                                                              14,
                                                              AppColors
                                                                  .grey150),
                                                    )
                                                  ],
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: AppColors.grey0
                                                            .withOpacity(0.08),
                                                        spreadRadius: 15,
                                                      ),
                                                      BoxShadow(
                                                        color: HexColor(
                                                                'CCE1F7')
                                                            .withOpacity(0.04),
                                                        spreadRadius: 30,
                                                      ),
                                                      BoxShadow(
                                                        color: HexColor(
                                                                'CCE1F7')
                                                            .withOpacity(0.02),
                                                        spreadRadius: 45,
                                                      ),
                                                    ],
                                                  ),
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            pet.photoURL),
                                                    radius: 50,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ],
                );
        }
      },
    );
  }
}
