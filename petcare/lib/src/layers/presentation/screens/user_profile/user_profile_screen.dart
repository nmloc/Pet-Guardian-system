import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/data/auth_repository.dart';
import 'package:petcare/src/layers/presentation/common_widgets/appbar_basic.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User user = ref.read(authRepositoryProvider).currentUser!;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const BasicAppBar(title: 'Profile'),
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: proportionateWidth(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: proportionateHeight(162),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.grey150,
                                spreadRadius: 17,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(user.photoURL!),
                            radius: 64,
                          ),
                        ),
                        Text(
                          user.displayName!,
                          style:
                              AppTextStyles.bodySemiBold(22, AppColors.grey800),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: proportionateHeight(16)),
                  customInfoBar('Email', user.email),
                  Divider(thickness: 1, color: AppColors.grey150),
                  customInfoBar('Phone Number', user.phoneNumber),
                  // Divider(thickness: 1, color: AppColors.grey150),
                  // customInfoBar('Weight', pet.weight),

                  SizedBox(height: proportionateHeight(24)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget customInfoBar(String title, String? value) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyRegular(14, AppColors.grey700),
        ),
        Text(
          value ?? 'unknown',
          style: AppTextStyles.bodySemiBold(14, AppColors.grey800),
        ),
      ],
    );
