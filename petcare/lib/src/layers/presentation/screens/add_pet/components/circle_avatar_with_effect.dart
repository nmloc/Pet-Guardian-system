import 'dart:io';

import 'package:flutter/material.dart';
import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';

class CircleAvatarWithEffect extends StatelessWidget {
  final String photoURL;

  const CircleAvatarWithEffect({
    super.key,
    required this.photoURL,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(proportionateHeight(16)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppColors.grey150)),
      child: Container(
        padding: EdgeInsets.all(proportionateHeight(16)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: AppColors.grey150)),
        child: CircleAvatar(
          radius: proportionateWidth(50),
          backgroundImage: FileImage(File(photoURL)),
        ),
      ),
    );
  }
}
