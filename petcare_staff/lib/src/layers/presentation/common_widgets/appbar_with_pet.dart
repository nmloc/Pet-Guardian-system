import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:petcare_staff/src/constants/app_colors.dart';
import 'package:petcare_staff/src/constants/app_sizes.dart';
import 'package:petcare_staff/src/constants/app_text_styles.dart';

class AppBarWithPet extends StatelessWidget {
  const AppBarWithPet({
    Key? key,
    required this.name,
    required this.photoURL,
    this.service,
  }) : super(key: key);

  final String name;
  final String photoURL;
  final String? service;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: proportionateWidth(12), right: proportionateWidth(24)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    alignment: Alignment.centerLeft,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.grey600,
                      size: 20,
                    ),
                    onPressed: () => context.pop(),
                  ),
                  Text('|',
                      style: AppTextStyles.bodyMedium(20, AppColors.grey150)),
                  SizedBox(width: proportionateWidth(4)),
                  service == null
                      ? Text('Pet Profile',
                          style: AppTextStyles.titleBold(18, AppColors.grey800))
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pet Profile',
                              style: AppTextStyles.bodyRegular(
                                  14, AppColors.grey600),
                            ),
                            Text(
                              service!,
                              style: AppTextStyles.titleBold(
                                  18, AppColors.grey800),
                            ),
                          ],
                        ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: proportionateHeight(10),
                  horizontal: proportionateWidth(14),
                ),
                decoration: BoxDecoration(
                  color: AppColors.grey150,
                  border: Border.all(color: AppColors.linear),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(photoURL),
                      radius: 10,
                    ),
                    SizedBox(width: proportionateWidth(4)),
                    Text(name,
                        style:
                            AppTextStyles.bodySemiBold(14, AppColors.grey800)),
                    SizedBox(width: proportionateWidth(4)),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.grey600,
                      size: 22,
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: proportionateHeight(12)),

          // Custom fade out divider
          Container(
            height: 1,
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
        ],
      ),
    );
  }
}
