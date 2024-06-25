import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/application/pet_service.dart';
import 'package:petcare/src/layers/data/auth_repository.dart';
import 'package:petcare/src/layers/data/pet_repository.dart';
import 'package:petcare/src/layers/domain/pet.dart';
import 'package:petcare/src/routing/app_router.dart';

import '../dashboard_screen_controller.dart';

class DrawerWidget extends ConsumerStatefulWidget {
  const DrawerWidget({super.key});

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
    return StreamBuilder(
      stream: ref.watch(petRepositoryProvider).watchPets(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Pet> petList = snapshot.data;
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
                        padding: EdgeInsets.symmetric(
                            vertical: proportionateHeight(12)),
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
                                      onTap: () => context
                                          .goNamed(AppRoute.userProfile.name),
                                    ),
                                    SizedBox(
                                      width: proportionateWidth(10),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                      SizedBox(height: proportionateHeight(20)),
                      _YourPetsWidget(petList),
                    ],
                  ),

                  // Section 4 - Menu
                  Padding(
                    padding:
                        EdgeInsets.only(right: proportionateHeight(375 / 3)),
                    child: Column(
                      children: [
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
                            style:
                                AppTextStyles.bodyMedium(16, AppColors.grey100),
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
                            style:
                                AppTextStyles.bodyMedium(16, AppColors.grey100),
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
                            style:
                                AppTextStyles.bodyMedium(16, AppColors.grey100),
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
      },
    );
  }
}

class _YourPetsWidget extends ConsumerWidget {
  final List<Pet> petList;

  const _YourPetsWidget(this.petList);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Pets',
          style: AppTextStyles.bodyMedium(16, AppColors.grey200),
        ),
        SizedBox(height: proportionateHeight(12)),
        // Section 3 - Your Pets Bar
        SizedBox(
          height: proportionateHeight(112),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: petList.length + 1,
            itemBuilder: (context, index) {
              if (index == petList.length) {
                // This is the "Add New" item
                return GestureDetector(
                  onTap: () {
                    ref.invalidate(newPetProvider);
                    context.goNamed(AppRoute.addPetSpecies.name);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: proportionateWidth(6),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: proportionateWidth(60),
                          height: proportionateHeight(60),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.grey900,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: AppColors.grey500,
                            ),
                          ),
                        ),
                        SizedBox(height: proportionateHeight(10)),
                        Text(
                          'Add new',
                          style:
                              AppTextStyles.bodyRegular(14, AppColors.grey200),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                final item = petList[index];
                bool isSelected =
                    ref.watch(selectedPetIdProvider) == petList[index].id;

                return GestureDetector(
                  onTap: () {
                    ref.read(selectedPetIdProvider.notifier).state =
                        petList[index].id;
                    context.goNamed(AppRoute.petProfile.name);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: proportionateWidth(6),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: proportionateWidth(60),
                          height: proportionateHeight(60),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.grey700,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.blue500
                                  : AppColors.grey700,
                              width: 2.0,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(item.photoURL),
                          ),
                        ),
                        SizedBox(height: proportionateHeight(10)),
                        Text(
                          item.name,
                          style: AppTextStyles.bodyRegular(
                            14,
                            isSelected ? AppColors.blue500 : AppColors.grey200,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
