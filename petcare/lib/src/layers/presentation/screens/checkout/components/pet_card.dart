// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/domain/pet.dart';
import 'package:petcare/src/layers/presentation/common_widgets/card_container.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  const PetCard({
    Key? key,
    required this.pet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(pet.photoURL),
                radius: 27,
              ),
              SizedBox(width: proportionateWidth(10)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    pet.name,
                    style: AppTextStyles.bodySemiBold(14, AppColors.grey800),
                  ),
                  Row(
                    children: [
                      Text(
                        pet.species,
                        style: AppTextStyles.bodyRegular(14, AppColors.grey600),
                      ),
                      Text(
                        ' | ',
                        style: AppTextStyles.bodyRegular(12, AppColors.grey300),
                      ),
                      Text(
                        pet.breed,
                        style: AppTextStyles.bodyRegular(14, AppColors.grey600),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          Container(
            height: proportionateHeight(40),
            width: proportionateWidth(40),
            decoration: BoxDecoration(
                color: pet.gender == 'Male'
                    ? AppColors.blue100
                    : AppColors.purple100,
                shape: BoxShape.circle),
            child: Image.asset(
              pet.gender == 'Male'
                  ? 'assets/icons/color-male.png'
                  : 'assets/icons/color-female.png',
              scale: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
