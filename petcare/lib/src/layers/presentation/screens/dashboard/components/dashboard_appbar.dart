import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/data/auth_repository.dart';
import 'package:petcare/src/routing/app_router.dart';

import '../dashboard_screen_controller.dart';

class DashboardAppBar extends ConsumerWidget {
  const DashboardAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
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
                    Text(
                        ref
                            .read(authRepositoryProvider)
                            .currentUser!
                            .displayName!
                            .split(' ')[0],
                        style:
                            AppTextStyles.bodySemiBold(16, AppColors.grey800)),
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
    );
  }
}
