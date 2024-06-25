// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:petcare/src/constants/app_colors.dart';
import 'package:petcare/src/constants/app_sizes.dart';
import 'package:petcare/src/constants/app_text_styles.dart';
import 'package:petcare/src/layers/domain/insurance_pack.dart';
import 'package:petcare/src/layers/domain/vaccine.dart';
import 'package:petcare/src/layers/presentation/common_widgets/card_container.dart';
import 'package:petcare/src/utils/int.dart';

class ItemCard extends StatelessWidget {
  final InsurancePack? insurancePack;
  final Vaccine? vaccine;
  const ItemCard({
    Key? key,
    this.insurancePack,
    this.vaccine,
  }) : super(key: key);

  bool isInsurance() => insurancePack != null;

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isInsurance()
              ? Image.asset(
                  'assets/images/pet-insurance.png',
                  fit: BoxFit.contain,
                  width: proportionateWidth(54),
                )
              : Image.network(vaccine!.photoURL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                    isInsurance()
                        ? '${insurancePack!.species} Insurance'
                        : '${vaccine!.species} Vaccine',
                    textAlign: TextAlign.end,
                    style: AppTextStyles.bodyBold(14, AppColors.grey800)),
                Text(isInsurance() ? insurancePack!.name : vaccine!.name,
                    textAlign: TextAlign.end,
                    style: AppTextStyles.bodySemiBold(14, AppColors.grey600)),
                Text(
                  isInsurance()
                      ? insurancePack!.price.toVND()
                      : vaccine!.price.toVND(),
                  textAlign: TextAlign.end,
                  style: AppTextStyles.bodyRegular(14, AppColors.grey600),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
