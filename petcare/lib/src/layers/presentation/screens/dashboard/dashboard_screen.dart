import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/layers/data/pet_repository.dart';
import 'package:petcare/src/layers/domain/pet.dart';
import 'package:petcare/src/layers/presentation/screens/dashboard/components/active_pet_profiles.dart';
import 'package:petcare/src/layers/presentation/screens/dashboard/components/dashboard_appbar.dart';
import 'package:petcare/src/layers/presentation/screens/dashboard/components/drawer.dart';
import 'package:petcare/src/layers/presentation/screens/dashboard/components/empty_content.dart';
import 'package:petcare/src/layers/presentation/screens/dashboard/dashboard_screen_controller.dart';
import 'package:petcare/src/routing/app_router.dart';
import 'components/menu_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Map<String, dynamic>> menuList = [
      {
        'title': 'Vaccines',
        'backgroundColor': AppColors.blue100,
        'onTap': () => context.goNamed(AppRoute.vaccines.name),
        'child': FaIcon(
          FontAwesomeIcons.syringe,
          color: AppColors.blue500,
          size: 80,
        ),
      },
      {
        'title': 'Orders',
        'backgroundColor': AppColors.orange100,
        'onTap': () => context.goNamed(AppRoute.orders.name),
        'child': SvgPicture.asset(
          'assets/icons/receipt.svg',
          width: proportionateHeight(88),
          height: proportionateHeight(72),
          colorFilter: ColorFilter.mode(AppColors.orange700, BlendMode.srcIn),
        ),
      },
      {
        'title': 'Find us',
        'backgroundColor': AppColors.green100,
        'onTap': () => context.goNamed(AppRoute.branches.name),
        'child': Image.asset(
          'assets/icons/doctor-pet.png',
          width: proportionateHeight(88),
          height: proportionateHeight(72),
        ),
      },
      {
        'title': 'Grooming',
        'backgroundColor': AppColors.purple100,
        'onTap': () => context.goNamed(AppRoute.booking.name,
            pathParameters: {"category": "Grooming"}),
        'child': Image.asset(
          'assets/icons/walk-dog.png',
          width: proportionateHeight(88),
          height: proportionateHeight(72),
        ),
      },
    ];
    return ZoomDrawer(
      style: DrawerStyle.style2,
      controller: ref.watch(zDrawerProvider),
      mainScreenScale: 0.0,
      slideWidth: AppSizes.screenWidth * 0.8,
      menuScreenWidth: AppSizes.screenWidth,
      borderRadius: 40.0,
      angle: 0,
      dragOffset: AppSizes.screenWidth * 0.2,
      menuScreen: const DrawerWidget(),
      mainScreen: Scaffold(
        body: SafeArea(
          child: StreamBuilder(
            stream: ref.watch(petRepositoryProvider).watchPets(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CupertinoActivityIndicator();
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                List<Pet> petList = snapshot.data!;
                return petList.isEmpty
                    ? const EmptyContent()
                    : Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: proportionateWidth(24)),
                            child: const DashboardAppBar(),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ActivePetProfiles(petList),
                                  GridView.builder(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: proportionateWidth(24)),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: 155.5 / 168.5,
                                    ),
                                    shrinkWrap: true,
                                    itemCount: menuList.length,
                                    itemBuilder: (context, index) {
                                      return MenuCard(
                                        title: menuList[index]['title'],
                                        backgroundColor: menuList[index]
                                            ['backgroundColor'],
                                        onTap: menuList[index]['onTap'],
                                        child: menuList[index]['child'],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
              }
            },
          ),
        ),
      ),
    );
  }
}
