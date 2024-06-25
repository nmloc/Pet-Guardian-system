import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare_staff/src/constants/app_colors.dart';
import 'package:petcare_staff/src/constants/app_sizes.dart';
import 'package:petcare_staff/src/constants/app_text_styles.dart';
import 'package:petcare_staff/src/layers/data/auth_repository.dart';
import 'package:petcare_staff/src/routing/app_router.dart';

import '../dashboard_screen_controller.dart';

class DrawerWidget extends ConsumerStatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends ConsumerState<DrawerWidget> {
  int selectedIndex = 0;
  int selectedListTileIndex = 0;

  void selectedListTileIndexTapped(int index) {
    selectedListTileIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: proportionateHeight(12)),
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
                                onTap: () =>
                                    context.goNamed(AppRoute.userProfile.name),
                              ),
                              SizedBox(
                                width: proportionateWidth(10),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Hello,',
                                      style: AppTextStyles.bodyRegular(
                                          14, AppColors.grey200)),
                                  Text(
                                      ref
                                          .read(authRepositoryProvider)
                                          .currentUser!
                                          .displayName!
                                          .split(' ')[0],
                                      style: AppTextStyles.bodySemiBold(
                                          16, AppColors.grey0)),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: AppColors.grey400,
                            ),
                            onPressed: () =>
                                ref.read(zDrawerProvider).close!.call(),
                          )
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
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: proportionateHeight(375 / 3)),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.dashboard_customize_outlined,
                      size: 25,
                      color: AppColors.grey150,
                    ),
                    title: Text(
                      'Dashboard',
                      style: AppTextStyles.bodyMedium(16, AppColors.grey100),
                    ),
                    selected: selectedListTileIndex == 0,
                    onTap: () {
                      selectedListTileIndexTapped(0);
                      context.pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.bubble_chart_outlined,
                      size: 25,
                      color: AppColors.grey150,
                    ),
                    title: Text(
                      'Contacts',
                      style: AppTextStyles.bodyMedium(16, AppColors.grey100),
                    ),
                    selected: selectedListTileIndex == 1,
                    onTap: () {
                      selectedListTileIndexTapped(1);
                      context.pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      CupertinoIcons.calendar,
                      size: 25,
                      color: AppColors.grey150,
                    ),
                    title: Text(
                      'Calendar',
                      style: AppTextStyles.bodyMedium(16, AppColors.grey100),
                    ),
                    selected: selectedListTileIndex == 2,
                    onTap: () {
                      selectedListTileIndexTapped(2);
                      context.pop();
                    },
                  ),
                  Divider(
                    thickness: 1.5,
                    color: AppColors.grey700,
                  ),
                  ListTile(
                    leading: Icon(
                      CupertinoIcons.person,
                      size: 25,
                      color: AppColors.grey150,
                    ),
                    title: Text(
                      'Account',
                      style: AppTextStyles.bodyMedium(16, AppColors.grey100),
                    ),
                    selected: selectedListTileIndex == 3,
                    onTap: () {
                      selectedListTileIndexTapped(3);
                      context.goNamed(AppRoute.profile.name);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      CupertinoIcons.gear,
                      size: 25,
                      color: AppColors.grey150,
                    ),
                    title: Text(
                      'Settings',
                      style: AppTextStyles.bodyMedium(16, AppColors.grey100),
                    ),
                    selected: selectedListTileIndex == 4,
                    onTap: () {
                      selectedListTileIndexTapped(4);
                      context.pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      CupertinoIcons.square_arrow_left,
                      size: 25,
                      color: AppColors.grey150,
                    ),
                    title: Text(
                      'Sign out',
                      style: AppTextStyles.bodyMedium(16, AppColors.grey100),
                    ),
                    selected: selectedListTileIndex == 5,
                    onTap: () {
                      selectedListTileIndexTapped(5);
                      ref.watch(authRepositoryProvider).signOut();
                      context.goNamed(AppRoute.signIn.name);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
